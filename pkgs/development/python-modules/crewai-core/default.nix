{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  appdirs,
  cryptography,
  httpx,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,
  packaging,
  portalocker,
  pydantic,
  pyjwt,
  rich,
  tomli,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "crewai-core";
  version = "1.15.15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crewAIInc";
    repo = "crewAI";
    tag = finalAttrs.version;
    hash = "sha256-5c1kRoBOSFDqN04TaWgrQu3d0krQRh7Jx37k7nSq+ck=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib/crewai-core";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "opentelemetry-api"
    "opentelemetry-exporter-otlp-proto-http"
    "opentelemetry-sdk"
    "portalocker"
    "pydantic"
    "tomli"
  ];

  dependencies = [
    appdirs
    cryptography
    httpx
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    packaging
    portalocker
    pydantic
    pyjwt
    rich
    tomli
  ];

  pythonImportsCheck = [ "crewai_core" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests"
  ];

  pytestFlags = [
    # Avoid loading the repository-wide conftest.py (needs many optional test deps)
    "--confcutdir=tests"
    # Drop addopts from the repository-wide pyproject.toml (xdist, socket, timeout)
    "--override-ini=addopts="
  ];

  meta = {
    description = "Shared utilities for CrewAI (version, paths, user-data, telemetry, printer)";
    homepage = "https://github.com/crewAIInc/crewAI/tree/main/lib/crewai-core";
    changelog = "https://github.com/crewAIInc/crewAI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
