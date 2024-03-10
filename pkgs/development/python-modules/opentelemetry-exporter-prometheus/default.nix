{ lib
, buildPythonPackage
, pythonOlder
, hatchling
, opentelemetry-api
, opentelemetry-sdk
, opentelemetry-test-utils
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) src;
  pname = "opentelemetry-exporter-prometheus";
  version = "0.44b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-prometheus";

  build-system = [
    hatchling
  ];

  dependencies = [
    opentelemetry-api
    opentelemetry-sdk
    prometheus-client
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.prometheus" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-prometheus";
    description = "Prometheus Metric Exporter for OpenTelemetry";
  };
}
