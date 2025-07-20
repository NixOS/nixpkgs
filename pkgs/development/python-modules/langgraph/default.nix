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
  langgraph-prebuilt,
  langgraph-sdk,
  xxhash,

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
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "langgraph";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = version;
    hash = "sha256-bTxtfduuuyRITZqhk15aWwxNwiZ7TMTgBOEPat6zVIc=";
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
    langgraph-prebuilt
    langgraph-sdk
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
    # test is flaky due to pydantic error on the exception
    "test_doesnt_warn_valid_schema"
    "test_tool_node_inject_store"

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

    # pydantic.errors.PydanticForbiddenQualifier,
    # see https://github.com/langchain-ai/langgraph/issues/4360
    "test_state_schema_optional_values"
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
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "([0-9.]+)"
    ];
  };

  meta = {
    description = "Build resilient language agents as graphs";
    homepage = "https://github.com/langchain-ai/langgraph";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
