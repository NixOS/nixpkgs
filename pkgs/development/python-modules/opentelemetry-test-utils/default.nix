{ lib
, callPackage
, buildPythonPackage
, pythonOlder
, asgiref
, hatchling
, opentelemetry-api
, opentelemetry-sdk
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-test-utils";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/tests/opentelemetry-test-utils";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
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
