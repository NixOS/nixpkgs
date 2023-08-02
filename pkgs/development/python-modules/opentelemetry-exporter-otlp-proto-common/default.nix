{ lib
, buildPythonPackage
, pythonOlder
, hatchling
, opentelemetry-api
, opentelemetry-proto
, opentelemetry-sdk
, opentelemetry-test-utils
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp-proto-common";
  disabled = pythonOlder "3.7";

  sourceRoot = "source/exporter/opentelemetry-exporter-otlp-proto-common";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-sdk
    opentelemetry-proto
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.common" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-common";
    description = "OpenTelemetry Protobuf encoding";
  };
}
