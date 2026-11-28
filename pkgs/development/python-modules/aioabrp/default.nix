{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  packaging,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioabrp";
  version = "0.10.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "mtandersson";
    repo = "aioabrp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AzXVEd8LPoP46WLPmvCHB8k4pMry5I0QMI1XmVNJLO8=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    packaging
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aioabrp" ];

  meta = {
    description = "Async Python client for the A Better Routeplanner (ABRP) / Iternio telemetry API";
    homepage = "https://github.com/mtandersson/aioabrp";
    changelog = "https://github.com/mtandersson/aioabrp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
