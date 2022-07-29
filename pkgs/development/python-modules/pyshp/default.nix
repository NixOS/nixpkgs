{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyshp";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TK7IL9jdCW/rqCF4WAaLrLKjtZUPQ8BIxtwyo0idWvE=";
  };

  pythonImportsCheck = [
    "shapefile"
  ];

  meta = with lib; {
    description = "Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
