{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  poetry-core,

  # dependencies
  aiosqlite,
  langgraph-checkpoint,

  # testing
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-sqlite";
  version = "2.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointsqlite==${version}";
    hash = "sha256-UUlrhQS0C2rPp//+LwU2rgR4R3AM5fM9X3CYvi/DAy8=";
  };

  sourceRoot = "${src.name}/libs/checkpoint-sqlite";

  build-system = [ poetry-core ];

  dependencies = [
    aiosqlite
    langgraph-checkpoint
  ];

  pythonRelaxDeps = [
    "aiosqlite"

    # Checkpoint clients are lagging behind langgraph-checkpoint
    "langgraph-checkpoint"
  ];

  pythonImportsCheck = [ "langgraph.checkpoint.sqlite" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "checkpointsqlite==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    description = "Library with a SQLite implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-sqlite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
