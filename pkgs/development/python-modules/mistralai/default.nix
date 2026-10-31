{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  eval-type-backport,
  httpx2,
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

  # tests
  opentelemetry-sdk,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistralai";
  version = "3.6.0";
  pyproject = true;
  __structuredAttrs = true;

  # Upstream stopped tagging releases on GitHub after v3.2.0
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HNEw2gGXnY7Nw3Soi7eogFJLMYor40tuaQE8ozHenXA=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "opentelemetry-semantic-conventions"
  ];
  dependencies = [
    eval-type-backport
    httpx2
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
    mcp = [
      mcp
    ];
    gcp = [
      google-auth
      requests
    ];
  };

  pythonImportsCheck = [ "mistralai" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.agents
  ++ finalAttrs.passthru.optional-dependencies.gcp;

  disabledTestPaths = [
    # ImportError: cannot import name 'HTTPX2ClientInstrumentor' from 'opentelemetry.instrumentation.httpx'
    # (requires opentelemetry-instrumentation-httpx>=0.65b0)
    "src/mistralai/extra/tests/test_otel_tracing.py"

    # ModuleNotFoundError: No module named 'livekit'
    "src/mistralai/extra/tests/voice_agents/"
  ];

  meta = {
    description = "Python client library for Mistral AI platform";
    homepage = "https://github.com/mistralai/client-python";
    changelog = "https://github.com/mistralai/client-python/blob/main/RELEASES.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      mana-byte
    ];
  };
})
