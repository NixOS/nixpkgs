{ lib
, buildPythonPackage
, pythonOlder
, hatchling
, opentelemetry-api
, protobuf
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-proto";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-proto";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    protobuf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.proto" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-proto";
    description = "OpenTelemetry Python Proto";
  };
}
