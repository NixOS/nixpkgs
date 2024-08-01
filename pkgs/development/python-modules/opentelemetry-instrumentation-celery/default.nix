{
  buildPythonPackage,
  celery,
  pythonOlder,
  pytestCheckHook,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-celery";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-celery";

  build-system = [ hatchling ];

  dependencies = [
    celery
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.celery" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-celery";
    description = "OpenTelemetry Celery instrumentation";
  };
}
