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
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-duckdb";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointduckdb==${version}";
    hash = "sha256-ppgViNRkkCTOGPfdB04DOnEzFgHN1KGDLLVjuwhRgNE=";
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
    inherit (langgraph-sdk) updateScript;

    skipBulkUpdate = true; # Broken, see https://github.com/NixOS/nixpkgs/issues/379898
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
