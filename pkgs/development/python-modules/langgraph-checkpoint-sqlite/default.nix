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
  version = "2.0.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointpostgres==${version}";
    hash = "sha256-Vz2ZoikEZuMvt3j9tvBIcXCwWSrCV8MI7x9PIHodl8Y=";
  };

  sourceRoot = "${src.name}/libs/checkpoint-sqlite";

  build-system = [ poetry-core ];

  dependencies = [
    aiosqlite
    langgraph-checkpoint
  ];

  # Checkpoint clients are lagging behind langgraph-checkpoint
  pythonRelaxDeps = [ "langgraph-checkpoint" ];

  pythonImportsCheck = [ "langgraph.checkpoint.sqlite" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpointsqlite==${src.tag}";
    description = "Library with a SQLite implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-sqlite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
