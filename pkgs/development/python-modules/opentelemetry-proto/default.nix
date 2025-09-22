{
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-api,
  protobuf,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-proto";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-proto";

  pythonRelaxDeps = [ "protobuf" ];

  build-system = [ hatchling ];

  dependencies = [ protobuf ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "opentelemetry.proto" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-proto";
    description = "OpenTelemetry Python Proto";
  };
}
