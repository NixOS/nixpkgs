{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  poetry-core,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "incomfort-client";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "incomfort-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OxrsRoP3HLHEE2YVLUEXA+VlYNoAJR+1Uph11M/Zv68=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "incomfortclient" ];

  meta = {
    description = "Python module to poll Intergas boilers via a Lan2RF gateway";
    homepage = "https://github.com/zxdavb/incomfort-client";
    changelog = "https://github.com/jbouwh/incomfort-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
