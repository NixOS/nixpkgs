{
  lib,
  buildPythonPackage,
  pythonOlder,
  asgiref,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
  opentelemetry-util-http,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-asgi";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-asgi";

  build-system = [ hatchling ];

  dependencies = [
    asgiref
    opentelemetry-instrumentation
    opentelemetry-api
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.asgi" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-asgi";
    description = "ASGI instrumentation for OpenTelemetry";
  };
}
