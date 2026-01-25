{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  setuptools,
}:

buildPythonPackage rec {
  pname = "millheater";
  version = "012.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pymill";
    tag = version;
    hash = "sha256-tR6MZIgCazGcXRIaSXyDYIEp+kD6xyrpOXORbi8LV7E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "mill" ];

  meta = {
    description = "Python library for Mill heater devices";
    homepage = "https://github.com/Danielhiversen/pymill";
    changelog = "https://github.com/Danielhiversen/pymill/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
