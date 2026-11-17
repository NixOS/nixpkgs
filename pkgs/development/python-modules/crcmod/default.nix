{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "crcmod";
  version = "1.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3HBRoNtfK9SGZamQ0+wcwwWkZqdzWMpEkoJvQfKDYB4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "crcmod" ];

  meta = {
    description = "Python module for generating objects that compute the Cyclic Redundancy Check (CRC)";
    homepage = "https://crcmod.sourceforge.net/";
    license = lib.licenses.mit;
  };
})
