{
  buildPythonPackage,
  pythonOlder,
  django,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-asgi,
  opentelemetry-instrumentation-wsgi,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
  opentelemetry-util-http,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-django";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-django";

  build-system = [ hatchling ];

  dependencies = [
    django
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-wsgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  passthru.optional-dependencies = {
    asgi = [ opentelemetry-instrumentation-asgi ];
  };

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ] ++ passthru.optional-dependencies.asgi;

  pythonImportsCheck = [ "opentelemetry.instrumentation.django" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-django";
    description = "OpenTelemetry Instrumentation for Django";
  };
}
