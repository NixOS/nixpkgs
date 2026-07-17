{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-duco-connectivity";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ronaldvdmeer";
    repo = "python-duco-connectivity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Txm7l7fVkEcUIX2J5CEF3OLLgTiT9O/xva0tSCCMZpI=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "duco_connectivity" ];

  meta = {
    description = "Async HTTP client for the local Duco Connectivity API";
    homepage = "https://github.com/ronaldvdmeer/python-duco-connectivity";
    changelog = "https://github.com/ronaldvdmeer/python-duco-connectivity/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
