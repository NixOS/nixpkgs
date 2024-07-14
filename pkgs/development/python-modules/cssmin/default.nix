{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "cssmin";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4BLwzIQB788mIDMjOQEVZHOK4yvoyEsuQ86L6uwQZ7Y=";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Python port of the YUI CSS compression algorithm";
    mainProgram = "cssmin";
    homepage = "https://github.com/zacharyvoase/cssmin";
    license = licenses.bsd3;
  };
}
