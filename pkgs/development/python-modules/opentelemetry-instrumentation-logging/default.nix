{
  buildPythonPackage,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-test-utils,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-logging";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-logging";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [
    "--benchmark-disable"
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.logging" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-logging";
    description = "Logging instrumentation for OpenTelemetry";
  };
}
