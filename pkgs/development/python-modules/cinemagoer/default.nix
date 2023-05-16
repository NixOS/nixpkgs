{ lib
, buildPythonPackage
, fetchPypi
, lxml
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "cinemagoer";
<<<<<<< HEAD
  version = "2023.5.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XOHXeuZUZwFhjxHlsVVqGdGO3srRttfZaXPsNJQbGPI=";
=======
  version = "2022.12.27";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uUq/6Uijv6krBNCa5ftBWG/uYLs/5pLyDONLvBoxjYo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    lxml
    sqlalchemy
  ];

  # Tests require networking, and https://github.com/cinemagoer/cinemagoer/issues/240
  doCheck = false;

  pythonImportsCheck = [ "imdb" ]; # Former "imdbpy", upstream is yet to rename here

  meta = with lib; {
    description = "A Python package for retrieving and managing the data of the IMDb movie database about movies and people";
    downloadPage = "https://github.com/cinemagoer/cinemagoer/";
    homepage = "https://cinemagoer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
  };
}
