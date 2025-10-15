{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  hatchling,

  # dependencies
  aiosqlite,
  langgraph-checkpoint,
  sqlite-vec,

  # testing
  pytest-asyncio,
  pytestCheckHook,
  sqlite,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-sqlite";
  version = "2.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointsqlite==${version}";
    hash = "sha256-v/gRYkiS4AR1epWwPdG/QYbnUYte894kHTn5F58pVGI=";
  };

  sourceRoot = "${src.name}/libs/checkpoint-sqlite";

  build-system = [ hatchling ];

  dependencies = [
    aiosqlite
    langgraph-checkpoint
    sqlite-vec
  ];

  pythonRelaxDeps = [
    "aiosqlite"

    # Bug: version is showing up as 0.0.0
    # https://github.com/NixOS/nixpkgs/issues/427197
    "sqlite-vec"

    # Checkpoint clients are lagging behind langgraph-checkpoint
    "langgraph-checkpoint"
  ];

  pythonImportsCheck = [ "langgraph.checkpoint.sqlite" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    sqlite
  ];

  disabledTestPaths = [
    # Failed: 'flaky' not found in `markers` configuration option
    "tests/test_ttl.py"
  ];

  disabledTests = [
    # AssertionError: (fails object comparison due to extra runtime fields)
    # https://github.com/langchain-ai/langgraph/issues/5604
    "test_combined_metadata"
    "test_asearch"
    "test_search"
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "checkpointsqlite==";
      ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    description = "Library with a SQLite implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-sqlite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
}
