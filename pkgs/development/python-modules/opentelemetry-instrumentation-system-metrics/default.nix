{
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-instrumentation,
  opentelemetry-api,
  opentelemetry-test-utils,
  psutil,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-system-metrics";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-system-metrics";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-instrumentation
    opentelemetry-api
    psutil
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.system_metrics" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-system-metrics";
    description = "OpenTelemetry System Metrics Instrumentation";
  };
}
