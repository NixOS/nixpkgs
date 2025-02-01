{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  langgraph-checkpoint,
  aiosqlite,
  pytest-asyncio,
  pytestCheckHook,
  langgraph-sdk,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-sqlite";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/checkpointsqlite==${version}";
    hash = "sha256-/pHJtK691anqn2It4ZstCGXJS0JGtdKZvqS9f3ly+FQ=";
  };

  sourceRoot = "${src.name}/libs/checkpoint-sqlite";

  build-system = [ poetry-core ];

  dependencies = [
    aiosqlite
    langgraph-checkpoint
  ];

  pythonImportsCheck = [ "langgraph.checkpoint.sqlite" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpointsqlite==${version}";
    description = "Library with a SQLite implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-sqlite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
