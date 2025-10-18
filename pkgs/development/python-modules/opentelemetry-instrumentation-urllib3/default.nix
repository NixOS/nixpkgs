{
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  urllib3,
  wrapt,

  # tests
  httpretty,
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-urllib3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-urllib3";

  build-system = [ hatchling ];

  dependencies = [
    urllib3
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    httpretty
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.urllib3" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib3";
    description = "OpenTelemetry urllib3 instrumentation";
  };
}
