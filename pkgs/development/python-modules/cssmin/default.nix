{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cssmin";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4BLwzIQB788mIDMjOQEVZHOK4yvoyEsuQ86L6uwQZ7Y=";
  };

  build-system = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "cssmin" ];

  meta = {
    description = "Python port of the YUI CSS compression algorithm";
    mainProgram = "cssmin";
    homepage = "https://github.com/zacharyvoase/cssmin";
    license = lib.licenses.bsd3;
  };
})
