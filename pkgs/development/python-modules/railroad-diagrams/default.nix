{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "railroad-diagrams";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qRMyuskAyzw2czH6m2mfCJe8+GtyZPZUWGdd9DDQTOM=";
  };

  # This is a dependency of pyparsing, which is a dependency of pytest
  doCheck = false;

  pythonImportsCheck = [ "railroad" ];

  meta = {
    description = "Module to generate SVG railroad syntax diagrams";
    homepage = "https://github.com/tabatkins/railroad-diagrams";
    license = lib.licenses.cc0;
    maintainers = [ ];
  };
}
