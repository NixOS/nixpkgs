{ lib
, buildPythonPackage
, pythonOlder
, django
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-instrumentation-asgi
, opentelemetry-instrumentation-wsgi
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-django";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-django";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    django
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-asgi
    opentelemetry-instrumentation-wsgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.django" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-django";
    description = "OpenTelemetry Instrumentation for Django";
  };
}
