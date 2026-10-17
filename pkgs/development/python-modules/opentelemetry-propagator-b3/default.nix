{
  lib,
  buildPythonPackage,
  hatchling,
  typing-extensions,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-test-utils,
  pytestCheckHook,
  requests,
  pytest-benchmark,
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-propagator-b3";
  pyproject = true;

  sourceRoot = "${opentelemetry-api.src.name}/propagator/opentelemetry-propagator-b3";

  build-system = [ hatchling ];

  dependencies = [
    typing-extensions
    opentelemetry-api
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    pytest-benchmark
    requests
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "opentelemetry.propagators.b3" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/blob/main/propagator/opentelemetry-propagator-b3";
    description = "B3 Propagator for OpenTelemetry";
  };
}
