{
  buildPythonPackage,
  pythonOlder,
  asgiref,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-sdk,
}:

buildPythonPackage {
  inherit (opentelemetry-api) src;
  pname = "opentelemetry-test-utils";
  # This package is in the same repository as `opentelemetry-api`,
  # but its version is synchronized with `opentelemetry-instrumentation` in another repository.
  version = opentelemetry-instrumentation.version;
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/tests/opentelemetry-test-utils";

  build-system = [ hatchling ];

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
