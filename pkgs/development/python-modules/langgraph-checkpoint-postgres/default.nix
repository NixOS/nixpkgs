{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  langgraph-checkpoint,
  orjson,
  psycopg,
  psycopg-pool,
  langgraph-sdk,
  poetry-core,
  pythonOlder,
  postgresql,
  postgresqlTestHook,
  pytestCheckHook,
  pytest-asyncio,
  stdenvNoCC,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-postgres";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/checkpointpostgres==${version}";
    hash = "sha256-E3gdHWUYelR/xI3Cv3T2uVwsyt+tOkw9MjX7I2RAuiQ=";
  };

  postgresqlTestSetupPost = ''
    substituteInPlace tests/conftest.py \
      --replace-fail "DEFAULT_URI = \"postgres://postgres:postgres@localhost:5441/postgres?sslmode=disable\"" "DEFAULT_URI = \"postgres:///$PGDATABASE\""
  '';

  sourceRoot = "${src.name}/libs/checkpoint-postgres";

  build-system = [ poetry-core ];

  dependencies = [
    langgraph-checkpoint
    orjson
    psycopg
    psycopg-pool
  ];

  pythonRelaxDeps = [ "psycopg-pool" ];

  doCheck = !(stdenvNoCC.hostPlatform.isDarwin);

  pythonImportsCheck = [ "langgraph.checkpoint.postgres" ];

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
    pytest-asyncio
    pytestCheckHook
  ];

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
