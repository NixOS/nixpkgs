{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  eval-type-backport,
  httpx,
  jsonpath-python,
  opentelemetry-api,
  opentelemetry-semantic-conventions,
  pydantic,
  python-dateutil,
  typing-inspection,

  # optional-dependencies
  authlib,
  griffe,
  mcp,
  google-auth,
  requests,
  websockets,
  opentelemetry-exporter-otlp-proto-http,

  # tests
  opentelemetry-sdk,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistralai";
  version = "2.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-skcg4fa9WUNqQs3rqfwVovpQ65hCXqhDDyeJa7kAwNA=";
  };

  preBuild = ''
    python scripts/prepare_readme.py
  '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "opentelemetry-semantic-conventions"
  ];
  dependencies = [
    eval-type-backport
    httpx
    jsonpath-python
    opentelemetry-api
    opentelemetry-semantic-conventions
    pydantic
    python-dateutil
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
    realtime = [
      websockets
    ];
    telemetry = [
      opentelemetry-sdk
      opentelemetry-exporter-otlp-proto-http
    ];
  };

  pythonImportsCheck = [ "mistralai" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.agents
  ++ finalAttrs.passthru.optional-dependencies.gcp
  ++ finalAttrs.passthru.optional-dependencies.realtime
  ++ finalAttrs.passthru.optional-dependencies.telemetry;

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'opentelemetry.instrumentation'
    "src/mistralai/extra/tests/test_otel_tracing.py"
    # ModuleNotFoundError: No module named 'msgpack'
    "src/mistralai/extra/tests/test_workflow_encoding.py"
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
