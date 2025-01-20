{
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) src;
  pname = "opentelemetry-semantic-conventions";
  # This package is in the same repository as `opentelemetry-api`,
  # but its version is synchronized with `opentelemetry-instrumentation` in another repository.
  version = opentelemetry-instrumentation.version;
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-semantic-conventions";

  build-system = [ hatchling ];

  dependencies = [ opentelemetry-api ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "opentelemetry.semconv" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-semantic-conventions";
    description = "OpenTelemetry Semantic Conventions";
  };
}
