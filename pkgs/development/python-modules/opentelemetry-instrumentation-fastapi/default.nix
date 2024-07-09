{
  lib,
  buildPythonPackage,
  fastapi,
  hatchling,
  httpx,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-asgi,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
  opentelemetry-util-http,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-fastapi";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-fastapi";

  build-system = [ hatchling ];

  dependencies = [
    fastapi
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-asgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    httpx
    opentelemetry-test-utils
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.fastapi" ];

  meta = opentelemetry-instrumentation.meta // {
    description = "OpenTelemetry Instrumentation for fastapi";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-fastapi";
  };
}
