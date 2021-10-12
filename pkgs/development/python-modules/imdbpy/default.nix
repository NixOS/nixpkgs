{ lib
, buildPythonPackage
, fetchPypi
, lxml
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "imdbpy";
  version = "2021.4.18";

  src = fetchPypi {
    pname = "IMDbPY";
    inherit version;
    sha256 = "af57f03638ba3b8ab3d696bfef0eeaf6414385c85f09260aba0a16b32174853f";
  };

  propagatedBuildInputs = [
    lxml
    sqlalchemy
  ];

  # Tests require networking, and https://github.com/alberanid/imdbpy/issues/240
  doCheck = false;

  pythonImportsCheck = [ "imdb" ];

  meta = with lib; {
    description = "Python package for retrieving and managing the data of the IMDb database";
    homepage = "https://imdbpy.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ivar ];
  };
}
