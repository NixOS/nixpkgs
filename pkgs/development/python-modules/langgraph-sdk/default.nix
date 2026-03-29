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

buildPythonPackage (finalAttrs: {
  pname = "langgraph-sdk";
  version = "0.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "sdk==${finalAttrs.version}";
    hash = "sha256-J8QqbzJe5tW11Nuio2uFAJk2EZIL1LNGIbJn7TZvlaA=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/sdk-py";

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
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
