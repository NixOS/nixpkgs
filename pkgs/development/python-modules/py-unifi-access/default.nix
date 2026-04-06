{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pydantic,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-unifi-access";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "imhotep";
    repo = "py-unifi-access";
    tag = finalAttrs.version;
    hash = "sha256-FYhHTYQl+yGHcAu0APqdfca/YSMp3GSQmY7kSO4xkH8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "unifi_access_api" ];

  meta = {
    description = "Async Python client for the UniFi Access local API with WebSocket event support";
    homepage = "https://github.com/imhotep/py-unifi-access";
    changelog = "https://github.com/imhotep/py-unifi-access/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
