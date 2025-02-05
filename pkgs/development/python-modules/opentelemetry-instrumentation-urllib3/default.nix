{
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  httpretty,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  urllib3,
  wrapt,

  # tests
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-urllib3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/${pname}";

  build-system = [ hatchling ];

  dependencies = [
    httpretty
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    urllib3
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.urllib3" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/${pname}";
    description = "OpenTelemetry urllib3 instrumentation";
  };
}
