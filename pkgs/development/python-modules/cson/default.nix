{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  speg,
}:

buildPythonPackage (finalAttrs: {
  pname = "cson";
  version = "0.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-7owBZvzR9ReJiHGX4+g1Sse++jlvwpcGvOta8l7cngE=";
  };

  build-system = [ setuptools ];

  dependencies = [ speg ];

  pythonImportsCheck = [ "cson" ];

  meta = {
    description = "Python parser for the Coffeescript Object Notation (CSON)";
    homepage = "https://github.com/avakar/pycson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xworld21 ];
  };
})
