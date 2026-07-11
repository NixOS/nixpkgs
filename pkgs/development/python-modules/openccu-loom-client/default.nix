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
  version = "2026.7.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-loom-client";
    tag = finalAttrs.version;
    hash = "sha256-eI8fDslP4yVNamJtYTaMG7yw0liPAib0WmCUu+E9WUk=";
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
