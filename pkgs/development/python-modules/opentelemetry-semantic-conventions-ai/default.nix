{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
}:
let
  version = "0.4.15";
in
buildPythonPackage {
  pname = "opentelemetry-semantic-conventions-ai";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    pname = "opentelemetry_semantic_conventions_ai";
    inherit version;
    hash = "sha256-Et4XLR4R0hxugrv1eMfopxNYmn/adq+e14VjJWSii4E=";
  };

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-sdk
    opentelemetry-semantic-conventions
  ];

  pythonImportsCheck = [ "opentelemetry.semconv_ai" ];

  meta = {
    description = "Open-source observability for your GenAI or LLM application, based on OpenTelemetry";
    homepage = "https://github.com/traceloop/openllmetry";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
  };
}
