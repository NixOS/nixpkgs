{
  buildPythonPackage,
  googleapis-common-protos,
  hatchling,
  mocket,
  opentelemetry-api,
  opentelemetry-exporter-http-transport,
  opentelemetry-exporter-otlp-common,
  opentelemetry-exporter-otlp-proto-common,
  opentelemetry-proto,
  opentelemetry-sdk,
  opentelemetry-test-utils,
  requests,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp-proto-http";
  pyproject = true;

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp-proto-http";

  build-system = [ hatchling ];

  dependencies = [
    googleapis-common-protos
    opentelemetry-api
    opentelemetry-exporter-http-transport
    opentelemetry-exporter-otlp-common
    opentelemetry-exporter-otlp-proto-common
    opentelemetry-proto
    opentelemetry-sdk
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    mocket
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.http" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-http";
    description = "OpenTelemetry Collector Protobuf over HTTP Exporter";
  };
}
