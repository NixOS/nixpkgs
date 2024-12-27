{
  buildPythonPackage,
  pythonOlder,
  deprecated,
  googleapis-common-protos,
  grpcio,
  hatchling,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-common,
  opentelemetry-proto,
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp-proto-grpc";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp-proto-grpc";

  build-system = [ hatchling ];

  dependencies = [
    deprecated
    googleapis-common-protos
    grpcio
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-common
    opentelemetry-proto
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.grpc" ];

  __darwinAllowLocalNetworking = true;

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-grpc";
    description = "OpenTelemetry Collector Protobuf over gRPC Exporter";
  };
}
