{
  lib,
  bluepy,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pycryptodomex,
}:

buildPythonPackage (finalAttrs: {
  pname = "csrmesh";
  version = "0.10.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-T6ETVrEjFoZ2LwE3F8OvLdK9Y9ZvwBk33o5dT0pVnw4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bluepy
    pycryptodomex
  ];

  # Project has no test
  doCheck = false;
  pythonImportsCheck = [ "csrmesh" ];

  meta = {
    description = "Python implementation of the CSRMesh bridge protocol";
    homepage = "https://github.com/nkaminski/csrmesh";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
