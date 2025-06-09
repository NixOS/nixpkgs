{
  lib,
  stdenv,
  buildPythonPackage,
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

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-grpc";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
  ];

  optional-dependencies = {
    instruments = [ grpcio ];
  };

  env = {
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  nativeCheckInputs = [
    opentelemetry-test-utils
    grpcio
    pytestCheckHook
  ];

  preBuild = ''
    export TMPDIR=$(mktemp -d)
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
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
