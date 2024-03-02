{ buildPythonPackage
, flask
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-instrumentation-wsgi
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-flask";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-flask";

  format = "pyproject";

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    flask
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-wsgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.flask" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-flask";
    description = "Flask Middleware for OpenTelemetry based on the WSGI middleware";
  };
}
