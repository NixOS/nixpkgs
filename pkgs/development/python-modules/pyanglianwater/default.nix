{
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyanglianwater";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pyanglianwater";
    tag = version;
    hash = "sha256-q6a6YVXjRx7Q2SdWoLzrlOUQ96AjgSjvmfDKz5Fk23g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    pyjwt
  ];

  pythonImportsCheck = [ "pyanglianwater" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # tests are out of date
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pyanglianwater/releases/tag/${src.tag}";
    description = "Python API to interact with Anglian Water";
    homepage = "https://github.com/pantherale0/pyanglianwater";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
