{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  langgraph-checkpoint,

  # tests
  aiosqlite,
  dataclasses-json,
  grandalf,
  httpx,
  langgraph-checkpoint-postgres,
  langgraph-checkpoint-sqlite,
  langsmith,
  psycopg,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytest-repeat,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  postgresql,
  postgresqlTestHook,

  # passthru
  langgraph-sdk,
}:

buildPythonPackage rec {
  pname = "langgraph";
  version = "0.2.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/${version}";
    hash = "sha256-1Ch2V85omAKnXK9rMihNtyjIoOvmVUm8Dbdo5GBoik4=";
  };

  postgresqlTestSetupPost = ''
    substituteInPlace tests/conftest.py \
      --replace-fail "DEFAULT_POSTGRES_URI = \"postgres://postgres:postgres@localhost:5442/\"" "DEFAULT_POSTGRES_URI = \"postgres:///$PGDATABASE\""
  '';

  sourceRoot = "${src.name}/libs/langgraph";

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    langgraph-checkpoint
  ];

  pythonImportsCheck = [ "langgraph" ];

  # postgresql doesn't play nicely with the darwin sandbox:
  # FATAL:  could not create shared memory segment: Operation not permitted
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    aiosqlite
    dataclasses-json
    grandalf
    httpx
    langgraph-checkpoint-postgres
    langgraph-checkpoint-sqlite
    langsmith
    psycopg
    psycopg.pool
    pydantic
    pytest-asyncio
    pytest-mock
    pytest-repeat
    pytest-xdist
    pytestCheckHook
    syrupy
    postgresql
    postgresqlTestHook
  ];

  disabledTests = [
    "test_doesnt_warn_valid_schema" # test is flaky due to pydantic error on the exception
    # Disabling tests that requires to create new random databases
    "test_cancel_graph_astream"
    "test_cancel_graph_astream_events_v2"
    "test_channel_values"
    "test_fork_always_re_runs_nodes"
    "test_interruption_without_state_updates"
    "test_interruption_without_state_updates_async"
    "test_invoke_two_processes_in_out_interrupt"
    "test_nested_graph_interrupts"
    "test_no_modifier_async"
    "test_no_modifier"
    "test_pending_writes_resume"
    "test_remove_message_via_state_update"
  ];

  disabledTestPaths = [
    # psycopg.errors.InsufficientPrivilege: permission denied to create database
    "tests/test_pregel_async.py"
    "tests/test_pregel.py"
  ];

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    description = "Build resilient language agents as graphs";
    homepage = "https://github.com/langchain-ai/langgraph";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
