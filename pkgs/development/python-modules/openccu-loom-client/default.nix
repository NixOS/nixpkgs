{
  aiohomematic,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  openccu-loom-types,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-slugify,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openccu-loom-client";
  version = "2026.7.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-loom-client";
    tag = finalAttrs.version;
    hash = "sha256-zeWZYYu/TdGr0OpAmiu0HMsXjf79TDy8lPNPm8x5urY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohomematic
    aiohttp
    openccu-loom-types
    pydantic
    python-slugify
  ];

  pythonImportsCheck = [ "openccu_loom_client" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/SukramJ/openccu-loom-client/blob/${finalAttrs.src.tag}/changelog.md";
    description = "Async Python REST + WebSocket client for the openccu-loom daemon";
    homepage = "https://github.com/SukramJ/openccu-loom-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
