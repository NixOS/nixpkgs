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
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-pooldose";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmaertin";
    repo = "python-pooldose";
    tag = finalAttrs.version;
    hash = "sha256-03U6x1Q0f8oH58Z3IDUW82dc24Od9+fqF/fF0mbzcgg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    getmac
    websockets
  ];

  pythonImportsCheck = [ "pooldose" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/lmaertin/python-pooldose/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Unofficial async Python client for SEKO PoolDose devices";
    homepage = "https://github.com/lmaertin/python-pooldose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
