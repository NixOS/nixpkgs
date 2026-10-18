{
  aiohomematic,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-slugify,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openccu-loom-client";
  version = "2026.10.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-loom-client";
    tag = finalAttrs.version;
    hash = "sha256-Y1zqO1ELIcyZaIhdiELBKUsbLEop4a8t/r87+U9F69E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohomematic
    aiohttp
    pydantic
    python-slugify
  ];

  pythonImportsCheck = [ "openccu_loom_client" ];

  nativeCheckInputs = [
    gitMinimal
    pytest-asyncio
    pytestCheckHook
    pyyaml
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/SukramJ/openccu-loom-client/blob/${finalAttrs.src.tag}/changelog.md";
    description = "Async Python REST + WebSocket client for the openccu-loom daemon";
    homepage = "https://github.com/SukramJ/openccu-loom-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
