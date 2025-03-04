{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  logfire-api,
  httpx,
  eval-type-backport,
  griffe,
  pydantic-graph,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pydantic-ai-slim";
  version = "0.0.29";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${version}";
    hash = "sha256-UT2Nls4JRy2grefIn+1z2V/YxWnrl0uzzjIkpqyDGZM=";
  };

  build-system = [
    hatchling
  ];

  sourceRoot = "source/pydantic_ai_slim";

  dependencies = [
    pydantic
    logfire-api
    httpx
    eval-type-backport
    griffe
    pydantic-graph
  ];

  nativeCheckInputs = [
    pydantic
    logfire-api
    httpx
    eval-type-backport
    griffe
    pydantic-graph
  ];

  pythonImportsCheck = [
    "pydantic-ai-slim[openai,vertexai,groq,anthropic,mistral,cohere]"
  ];

  meta = {
    description = "Graph and finite state machine library";
    homepage = "https://github.com/pydantic/pydantic-ai";
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yomaq ];
  };
}
