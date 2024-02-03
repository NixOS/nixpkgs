{ lib
, buildPythonPackage
, pythonOlder
, hatchling
, opentelemetry-api
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-api) version src;
  pname = "opentelemetry-semantic-conventions";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-semantic-conventions";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.semconv" ];

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-semantic-conventions";
    description = "OpenTelemetry Semantic Conventions";
  };
}
