{ lib
, buildPythonPackage
, fetchPypi
, lxml
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "imdbpy";
  version = "2022.7.9";

  src = fetchPypi {
    pname = "IMDbPY";
    inherit version;
    sha256 = "sha256-gKXt+KhxE/8ipE0A/XbUIsQs/uzU6oIL4zdTuPJL9OY=";
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
