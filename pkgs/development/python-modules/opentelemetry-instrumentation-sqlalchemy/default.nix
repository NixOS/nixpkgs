{
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  hatchling,
  sqlalchemy_1_4,
  aiosqlite,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-sqlalchemy";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-sqlalchemy";

  build-system = [ hatchling ];

  dependencies = [
    sqlalchemy_1_4
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    aiosqlite
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.sqlalchemy" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-sqlalchemy";
    description = "OpenTelemetry SQLAlchemy instrumentation";
  };
}
