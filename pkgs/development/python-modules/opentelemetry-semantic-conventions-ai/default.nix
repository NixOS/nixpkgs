{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "opentelemetry-semantic-conventions-ai";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "opentelemetry_semantic_conventions_ai";
    inherit version;
    hash = "sha256-kLlpx9g44D4wqRUP/kZUPY5Y6dc3DHIh/TDUzk16G5Y=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "opentelemetry.semconv_ai" ];

  # no tests
  doCheck = false;

  meta = {
    description = "OpenTelemetry Semantic Conventions Extension for Large Language Models";
    homepage = "https://pypi.org/project/opentelemetry-semantic-conventions-ai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
