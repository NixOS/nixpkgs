{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  genai-prices,
  griffelib,
  httpx,
  opentelemetry-api,
  pydantic-graph,
  pydantic,
  typing-inspection,

}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-ai-slim";
  version = "1.101.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Giir7Q6Jfo2Pm7//kn/AvyDTb+r4nLzVux2GxNrSfdw=";
  };

  sourceRoot = "${finalAttrs.src.name}/pydantic_ai_slim";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    genai-prices
    griffelib
    httpx
    opentelemetry-api
    pydantic-graph
    pydantic
    typing-inspection
  ];

  pythonImportsCheck = [
    "pydantic_ai"
  ];

  doCheck = false;

  meta = {
    description = "GenAI Agent Framework, the Pydantic way";
    homepage = "https://github.com/pydantic/pydantic-ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
