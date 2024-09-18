{
  lib,
  stdenv,
  buildPythonPackage,
  fetchpatch2,
  pythonOlder,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
  wrapt,
  pytestCheckHook,
  grpcio,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-grpc";
  pyproject = true;

  disabled = pythonOlder "3.8";

  patches = [
    (fetchpatch2 {
      name = "grpcio-compatibility.patch";
      url = "https://github.com/open-telemetry/opentelemetry-python-contrib/commit/1c8d8ef5368c15d27c0973ce80787fd94c7b3176.patch";
      includes = [ "src/opentelemetry/instrumentation/grpc/grpcext/_interceptor.py" ];
      stripLen = 2;
      hash = "sha256-FH/VubT93kwh7nWQyPfECTIayMqWIjQYSEY5TER+4vY=";
    })
  ];

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-grpc";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
  ];

  passthru.optional-dependencies = {
    instruments = [ grpcio ];
  };

  nativeCheckInputs = [
    opentelemetry-test-utils
    grpcio
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # RuntimeError: Failed to bind to address
    "TestOpenTelemetryServerInterceptorUnix"
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.grpc" ];

  __darwinAllowLocalNetworking = true;

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-grpc";
    description = "OpenTelemetry Instrumentation for grpc";
  };
}
