{
  aiofiles,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  getmac,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-pooldose";
  version = "0.7.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmaertin";
    repo = "python-pooldose";
    tag = version;
    hash = "sha256-TOwogNRWmdbzEjvjSUYw9+5CXHfF2OXq8Jxaj3KsQ+A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    getmac
  ];

  pythonImportsCheck = [ "pooldose" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/lmaertin/python-pooldose/blob/${src.tag}/CHANGELOG.md";
    description = "Unoffical async Python client for SEKO PoolDose devices";
    homepage = "https://github.com/lmaertin/python-pooldose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
