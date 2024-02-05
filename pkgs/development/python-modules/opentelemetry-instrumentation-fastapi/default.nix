{ buildPythonPackage
, fastapi
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-instrumentation-asgi
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-fastapi";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-fastapi";

  format = "pyproject";

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    fastapi
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-asgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.fastapi" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-fastapi";
    description = "This library provides automatic and manual instrumentation of FastAPI web frameworks, instrumenting http requests served by applications utilizing the framework";
  };
}
