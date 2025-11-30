{
  buildPythonPackage,
  pythonOlder,
  deprecated,
  googleapis-common-protos,
  hatchling,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-common,
  opentelemetry-proto,
  opentelemetry-sdk,
  opentelemetry-test-utils,
  requests,
  responses,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp-proto-http";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp-proto-http";

  build-system = [ hatchling ];

  dependencies = [
    deprecated
    googleapis-common-protos
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-common
    opentelemetry-proto
    opentelemetry-sdk
    requests
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.http" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-http";
    description = "OpenTelemetry Collector Protobuf over HTTP Exporter";
  };
}
