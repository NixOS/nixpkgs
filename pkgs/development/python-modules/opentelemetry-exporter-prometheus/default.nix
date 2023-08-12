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
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-prometheus";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-prometheus";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
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
