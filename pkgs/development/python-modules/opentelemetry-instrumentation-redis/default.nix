{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  wrapt,
  redis,
  opentelemetry-test-utils,
  pythonOlder,
  pytestCheckHook,
  fakeredis,
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-redis";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-redis";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
  ];

  nativeCheckInputs = [
    fakeredis
    opentelemetry-test-utils
    pytestCheckHook
  ];

  optional-dependencies = {
    instruments = [ redis ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.redis" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-redis";
    description = "Redis instrumentation for OpenTelemetry";
  };
}
