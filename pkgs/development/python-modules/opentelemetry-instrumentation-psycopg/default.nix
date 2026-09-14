{
  buildPythonPackage,
  pytestCheckHook,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-dbapi,
  opentelemetry-test-utils,
  psycopg,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-psycopg";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-psycopg";

  build-system = [ hatchling ];

  dependencies = [
    psycopg
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-dbapi
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.psycopg" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-psycopg";
    description = "OpenTelemetry Psycopg Instrumentation";
  };
}
