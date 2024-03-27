DROP DATABASE cinema;
CREATE DATABASE cinema;
USE cinema;

CREATE TABLE cinema(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    city VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE room(
    number INT NOT NULL,
    type ENUM('normal', 'deluxe', 'VIP') NOT NULL,
    cinema_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (cinema_id) REFERENCES cinema(id),
    PRIMARY KEY(number, cinema_id) -- ensures that each room number is unique in a specific cinema 
);

CREATE TABLE movie(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    year YEAR NOT NULL,
    country VARCHAR(255) NOT NULL
);

CREATE TABLE show_movies (
    visitors INT NOT NULL,
    time DATETIME NOT NULL,
    cinema_id INT NOT NULL,
    room_number INT NOT NULL,
    movie_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (cinema_id, room_number) REFERENCES room(cinema_id, number),
    CONSTRAINT FOREIGN KEY (movie_id) REFERENCES movie(id),
    PRIMARY KEY(cinema_id, room_number) -- ensures that each movie show is uniquely identified by the cinema and room where it takes place
);

INSERT INTO cinema (name, city) VALUES 
('Cineplex', 'New York'),
('AMC Theatres', 'Los Angeles'),
('ODEON', 'London');

INSERT INTO room (number, type, cinema_id) VALUES 
(1, 'normal', 1),
(2, 'deluxe', 1),
(3, 'VIP', 2),
(1, 'normal', 3),
(2, 'normal', 3);


INSERT INTO movie (name, year, country) VALUES 
('Inception', 2010, 'USA'),
('The Shawshank Redemption', 1994, 'USA'),
('The Dark Knight', 2008, 'USA');

INSERT INTO show_movies (visitors, time, cinema_id, room_number, movie_id) VALUES 
(150, '2024-03-28 18:00:00', 1, 1, 1),
(200, '2024-03-28 20:00:00', 1, 2, 2),
(100, '2024-03-29 19:00:00', 2, 3, 3),
(120, '2024-03-30 15:00:00', 3, 1, 1),
(180, '2024-03-30 17:00:00', 3, 2, 3);

SELECT cinema.name AS cinema_name, room.number AS room_num, show_movies.time AS show_time 
FROM cinema
JOIN room ON cinema.cinema.id = room.cinema_id
JOIN show_movies ON (room.cinema_id, room.number) = (show_movies.cinema_id, show_movies.room_number)
WHERE room.type IN ('VIP', 'deluxe')
AND show_movies.movie_id = (SELECT id FROM movie WHERE movie.name = 'Inception')
ORDER BY cinema.name, room.number;

SELECT SUM(show_movies.visitors) AS visitors_num
FROM show_movies
JOIN room ON (show_movies.cinema_id, show_movies.room_number) = (room.cinema_id, room.number)
JOIN cinema ON room.cinema_id = cinema.id
JOIN movie ON show_movies.movie_id = movie.id
WHERE movie.name = 'The Dark Knight' AND room.type = 'VIP' AND cinema.name = 'AMC Theatres';

-- WHERE show_movies.movie_id = (SELECT id FROM movie WHERE movie.name = 'The Dark Knight') AND room.type = 'VIP' AND cinema.name = 'ODEON';

