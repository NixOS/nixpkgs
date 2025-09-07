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
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "sdk==${version}";
    hash = "sha256-CBX9tDYDrLCe/q+QS6ze4B6E5dVJhfsd6QB4U6kObTM=";
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

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "sdk==";
    };
  };

  meta = {
    description = "SDK for interacting with the LangGraph Cloud REST API";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/sdk-py";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
