{ lib
, buildPythonPackage
, pythonOlder
, backoff
, hatchling
, opentelemetry-api
, opentelemetry-exporter-otlp-proto-grpc
, opentelemetry-exporter-otlp-proto-http
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-exporter-otlp-proto-http
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp";
    description = "OpenTelemetry Collector Exporters";
  };
}
