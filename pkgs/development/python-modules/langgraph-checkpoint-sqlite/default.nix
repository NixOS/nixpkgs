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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-sqlite";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointsqlite==${version}";
    hash = "sha256-8JNPKaaKDM7VROd1n9TDALN6yxKRz1CuAultBcqBMG0=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "checkpoint-sqlite==(\\d+\\.\\d+\\.\\d+)"
    ];
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
