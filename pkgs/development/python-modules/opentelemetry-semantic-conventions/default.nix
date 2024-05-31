{
  lib,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-api,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) src;
  pname = "opentelemetry-semantic-conventions";
  version = "0.44b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-semantic-conventions";

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "opentelemetry.semconv" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-semantic-conventions";
    description = "OpenTelemetry Semantic Conventions";
  };
}
