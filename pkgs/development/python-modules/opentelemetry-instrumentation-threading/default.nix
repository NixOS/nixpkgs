{
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-api,
  opentelemetry-instrumentation,
  wrapt,

  # tests
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-threading";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-threading";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.threading" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-threading";
    description = "Threading instrumentation for OpenTelemetry";
  };
}
