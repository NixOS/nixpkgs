{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "airgradient";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Open-Air-Foundation";
    repo = "integration-home-assistant-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3W4Uf/PXB6Lk3lOFKB/sU4vDC7OPxU0SbWkFIIEMCYg=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "airgradient" ];

  meta = {
    description = "Module for AirGradient";
    homepage = "https://github.com/Open-Air-Foundation/integration-home-assistant-python";
    changelog = "https://github.com/Open-Air-Foundation/integration-home-assistant-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
