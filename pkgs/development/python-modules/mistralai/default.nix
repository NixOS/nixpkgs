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
  msgpack,
  requests,
  websockets,
  zstandard,
  opentelemetry-exporter-otlp-proto-http,

  # tests
  opentelemetry-instrumentation-httpx,
  opentelemetry-sdk,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mistralai";
  version = "2.9.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w7nU4fiduMhpuvKZMJ3JTLEg8Bvuv5L5OXeJYve3/fI=";
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
    workflow_payload_compression = [
      msgpack
      zstandard
    ];
  };

  pythonImportsCheck = [ "mistralai" ];

  nativeCheckInputs = [
    opentelemetry-instrumentation-httpx
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.agents
  ++ finalAttrs.passthru.optional-dependencies.gcp
  ++ finalAttrs.passthru.optional-dependencies.realtime
  ++ finalAttrs.passthru.optional-dependencies.telemetry
  ++ finalAttrs.passthru.optional-dependencies.workflow_payload_compression;

  disabledTestPaths = [
    # Local test servers cannot bind in the Nix sandbox.
    "src/mistralai/extra/tests/test_otel_tracing.py::TestOtelTracing::test_app_otel_does_not_enable_mistral_span_without_mistral_telemetry"
    "src/mistralai/extra/tests/test_otel_tracing.py::TestOtelTracing::test_concurrent_async_httpx_auto_instrumented_spans_are_genai_children"
    "src/mistralai/extra/tests/test_otel_tracing.py::TestOtelTracing::test_httpx_auto_instrumented_span_is_child_of_genai_span"
    "src/mistralai/extra/tests/test_otel_tracing.py::TestPerInstanceTracerProvider::test_get_telemetry_tracer_dedicated_provider_captures_app_spans"
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
