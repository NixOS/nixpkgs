{ lib
, buildPythonPackage
, pythonOlder
, backoff
, googleapis-common-protos
, grpcio
, hatchling
, opentelemetry-api
, opentelemetry-test-utils
, opentelemetry-exporter-otlp-proto-common
, pytest-grpc
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp-proto-grpc";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp-proto-grpc";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    backoff
    googleapis-common-protos
    grpcio
    opentelemetry-exporter-otlp-proto-common
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/performance/benchmarks/"
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.grpc" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-grpc";
    description = "OpenTelemetry Collector Protobuf over gRPC Exporter";
  };
}
