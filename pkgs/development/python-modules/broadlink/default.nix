{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
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
    changelog = "https://github.com/mjg59/python-broadlink/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
