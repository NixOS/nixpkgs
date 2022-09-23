{ lib
, buildPythonPackage
, fetchPypi
, lxml
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "cinemagoer";
  version = "2022.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8efe29dab44a7d275702f3160746015bd55c87b2eed85991dd57dda42594e6c6";
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
    maintainers = with maintainers; [ superherointj ];
  };
}
