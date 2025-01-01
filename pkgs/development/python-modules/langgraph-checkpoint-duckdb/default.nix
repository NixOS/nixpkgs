{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  langgraph-checkpoint,
  aiosqlite,
  duckdb,
  pytest-asyncio,
  pytestCheckHook,
  langgraph-sdk,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-duckdb";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointduckdb==${version}";
    hash = "sha256-wSrlFBfTcTgyE46uwv9GCyxRT1xVafgWyP2g87KUTAU=";
  };

  sourceRoot = "${src.name}/libs/checkpoint-duckdb";

  build-system = [ poetry-core ];

  dependencies = [
    aiosqlite
    duckdb
    langgraph-checkpoint
  ];

  # Checkpoint clients are lagging behind langgraph-checkpoint
  pythonRelaxDeps = [ "langgraph-checkpoint" ];

  pythonImportsCheck = [ "langgraph.checkpoint.duckdb" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [ "test_basic_store_ops" ]; # depends on networking

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpointduckdb==${version}";
    description = "Library with a DuckDB implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-duckdb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
