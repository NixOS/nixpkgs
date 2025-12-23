{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  langgraph-checkpoint,
  langgraph-prebuilt,
  langgraph-sdk,
  pydantic,
  xxhash,

  # tests
  aiosqlite,
  dataclasses-json,
  fakeredis,
  grandalf,
  httpx,
  langgraph-checkpoint-postgres,
  langgraph-checkpoint-sqlite,
  langsmith,
  psycopg,
  pytest-asyncio,
  pytest-mock,
  pytest-repeat,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  postgresql,
  postgresqlTestHook,
  redisTestHook,

  # passthru
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "langgraph";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = version;
    hash = "sha256-Lo/Vq48j1my+GoZATKo3gByz5WJrFJEU7pelzfFfDLQ=";
  };

  postgresqlTestSetupPost = ''
    substituteInPlace tests/conftest_store.py \
      --replace-fail "DEFAULT_POSTGRES_URI = \"postgres://postgres:postgres@localhost:5442/\"" "DEFAULT_POSTGRES_URI = \"postgres:///$PGDATABASE\""
    substituteInPlace tests/conftest_checkpointer.py \
      --replace-fail "DEFAULT_POSTGRES_URI = \"postgres://postgres:postgres@localhost:5442/\"" "DEFAULT_POSTGRES_URI = \"postgres:///$PGDATABASE\""
  '';

  sourceRoot = "${src.name}/libs/langgraph";

  build-system = [ hatchling ];

  dependencies = [
    langchain-core
    langgraph-checkpoint
    langgraph-prebuilt
    langgraph-sdk
    pydantic
    xxhash
  ];

  pythonImportsCheck = [ "langgraph" ];

  # postgresql doesn't play nicely with the darwin sandbox:
  # FATAL:  could not create shared memory segment: Operation not permitted
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    pytestCheckHook
    postgresql
    postgresqlTestHook
    redisTestHook
    fakeredis
    langgraph-checkpoint
  ];

  checkInputs = [
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
    syrupy
  ];

  disabledTests = [
    # Requires `langgraph dev` to be running
    "test_remote_graph_basic_invoke"
    "test_remote_graph_stream_messages_tuple"

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
    "tests/test_checkpoint_migration.py"
    "tests/test_large_cases.py"
    "tests/test_large_cases_async.py"
    "tests/test_pregel.py"
    "tests/test_pregel_async.py"
  ];

  # Since `langgraph` is the only unprefixed package, we have to use an explicit match
  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Build resilient language agents as graphs";
    homepage = "https://github.com/langchain-ai/langgraph";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
