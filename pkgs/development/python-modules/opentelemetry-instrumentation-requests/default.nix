{
  buildPythonPackage,
  requests,
  pythonOlder,
  pytestCheckHook,
  hatchling,
  httpretty,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
  opentelemetry-util-http,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-requests";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-requests";

  build-system = [ hatchling ];

  dependencies = [
    requests
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    httpretty
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.requests" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-requests";
    description = "OpenTelemetry Requests instrumentation";
  };
}
