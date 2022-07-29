{ lib, buildPythonPackage, fetchPypi
, setuptools }:

buildPythonPackage rec {
  version = "2.3.1";
  pname = "pyshp";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TK7IL9jdCW/rqCF4WAaLrLKjtZUPQ8BIxtwyo0idWvE=";
  };

  pythonImportsCheck = [ "shapefile" ];

  meta = with lib; {
    description = "Pure Python read/write support for ESRI Shapefile format";
    homepage = "https://github.com/GeospatialPython/pyshp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
