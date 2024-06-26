{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-sdk,
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

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-grpc";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-sdk
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
