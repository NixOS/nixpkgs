{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "broadlink";
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ID5YpUjio68xChs6ZhTQBW995kqbmwsASRJKQ1a5M2U=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "broadlink" ];

  meta = {
    description = "Python API for controlling Broadlink IR controllers";
    homepage = "https://github.com/mjg59/python-broadlink";
    changelog = "https://github.com/mjg59/python-broadlink/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
