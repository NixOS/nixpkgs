{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  eval-type-backport,
  httpx,
  httpcore,
  invoke,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
  pydantic,
  python-dateutil,
  pyyaml,
  typing-inspection,

  # optional-dependencies
  authlib,
  griffe,
  mcp,
  google-auth,
  requests,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistralai";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y1et8Ez5TAge0kk/a9fA1zcgPStYf+6aO19OLhMGk/8=";
  };

  preBuild = ''
    python scripts/prepare_readme.py
  '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "opentelemetry-exporter-otlp-proto-http"
    "opentelemetry-semantic-conventions"
  ];
  dependencies = [
    eval-type-backport
    httpx
    invoke
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    pydantic
    python-dateutil
    pyyaml
    typing-inspection
  ];

  optional-dependencies = {
    agents = [
      authlib
      griffe
      mcp
    ];
    gcp = [
      google-auth
      requests
    ];
  };

  pythonImportsCheck = [ "mistralai" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python client library for Mistral AI platform";
    homepage = "https://github.com/mistralai/client-python";
    changelog = "https://github.com/mistralai/client-python/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mana-byte
    ];
  };
})
