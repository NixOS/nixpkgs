{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  langgraph-checkpoint,
  langgraph-sdk,
  orjson,
  psycopg,
  psycopg-pool,
  poetry-core,
  pythonOlder,
  pgvector,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  pytest-asyncio,
  stdenvNoCC,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-postgres";
  version = "2.0.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointpostgres==${version}";
    hash = "sha256-yHLkFUp+q/XOt9Y9Dog2Tgs/K2CU7Bfkkucdr9vAKSg=";
  };

  postgresqlTestSetupPost = ''
    substituteInPlace tests/conftest.py \
      --replace-fail "DEFAULT_URI = \"postgres://postgres:postgres@localhost:5441/postgres?sslmode=disable\"" "DEFAULT_URI = \"postgres:///$PGDATABASE\"" \
      --replace-fail "DEFAULT_POSTGRES_URI = \"postgres://postgres:postgres@localhost:5441/\"" "DEFAULT_POSTGRES_URI = \"postgres:///\""
  '';

  sourceRoot = "${src.name}/libs/checkpoint-postgres";

  build-system = [ poetry-core ];

  dependencies = [
    langgraph-checkpoint
    orjson
    psycopg
    psycopg-pool
  ];

  pythonRelaxDeps = [
    "langgraph-checkpoint"
    "psycopg-pool"
  ];

  doCheck = !(stdenvNoCC.hostPlatform.isDarwin);

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    (postgresql.withPackages (p: with p; [ pgvector ]))
    postgresqlTestHook
  ];

  preCheck = ''
    export postgresqlTestUserOptions="LOGIN SUPERUSER"
  '';

  disabledTests = [
    # psycopg.errors.FeatureNotSupported: extension "vector" is not available
    # /nix/store/...postgresql-and-plugins-16.4/share/postgresql/extension/vector.control": No such file or directory.
    "test_embed_with_path"
    "test_embed_with_path_sync"
    "test_scores"
    "test_search_sorting"
    "test_vector_store_initialization"
    "test_vector_insert_with_auto_embedding"
    "test_vector_update_with_embedding"
    "test_vector_search_with_filters"
    "test_vector_search_pagination"
    "test_vector_search_edge_cases"
  ];

  pythonImportsCheck = [ "langgraph.checkpoint.postgres" ];

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    description = "Library with a Postgres implementation of LangGraph checkpoint saver";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint-postgres";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpointpostgres==${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
