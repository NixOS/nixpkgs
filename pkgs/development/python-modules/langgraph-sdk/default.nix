{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  httpx,
  httpx-sse,
  orjson,
  typing-extensions,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-sdk";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-UY3AChShKfOrtOQzOm5vi3Yy3rlBc+TAje9L2L6My/U=";
  };

  sourceRoot = "${src.name}/libs/sdk-py";

  build-system = [ hatchling ];

  dependencies = [
    httpx
    httpx-sse
    orjson
    typing-extensions
  ];

  disabledTests = [ "test_aevaluate_results" ]; # Compares execution time to magic number

  pythonImportsCheck = [ "langgraph_sdk" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "sdk==";
  };

  meta = {
    description = "SDK for interacting with the LangGraph Cloud REST API";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/sdk-py";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
