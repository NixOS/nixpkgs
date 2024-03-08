{ lib
, buildPythonPackage
, pythonOlder
, backoff
, googleapis-common-protos
, hatchling
, opentelemetry-api
, opentelemetry-exporter-otlp-proto-common
, opentelemetry-test-utils
, requests
, responses
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-exporter-otlp-proto-http";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-otlp-proto-http";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    backoff
    googleapis-common-protos
    opentelemetry-exporter-otlp-proto-common
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
