{
  buildPythonPackage,
  hatchling,
  opentelemetry-api,
  opentelemetry-exporter-http-transport,
  opentelemetry-instrumentation,
  opentelemetry-sdk,
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) src;
  inherit (opentelemetry-instrumentation) version;
  pname = "opentelemetry-exporter-otlp-common";
  pyproject = true;

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp-common";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-sdk
    opentelemetry-exporter-http-transport
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.common" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-common";
    description = "OpenTelemetry OTLP HTTP export utilities";
  };
}
