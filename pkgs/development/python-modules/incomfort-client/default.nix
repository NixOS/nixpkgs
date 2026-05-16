{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  poetry-core,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "incomfort-client";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "incomfort-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-myjT9mx3QfXFTVDPYusLGrpB61+qywu5r0K5InzMhYA=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
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
