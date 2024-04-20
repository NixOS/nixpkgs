{ lib
, buildPythonPackage
, pythonOlder
, asgiref
, hatchling
, opentelemetry-api
, opentelemetry-sdk
}:

buildPythonPackage {
  inherit (opentelemetry-api) src;
  pname = "opentelemetry-test-utils";
  version = "0.44b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/tests/opentelemetry-test-utils";

  build-system = [
    hatchling
  ];

  dependencies = [
    asgiref
    opentelemetry-api
    opentelemetry-sdk
  ];

  pythonImportsCheck = [ "opentelemetry.test" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/tests/opentelemetry-test-utils";
    description = "Test utilities for OpenTelemetry unit tests";
  };
}
