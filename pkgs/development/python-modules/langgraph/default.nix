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
  langgraph-sdk,

  # tests
  aiosqlite,
  dataclasses-json,
  grandalf,
  httpx,
  langgraph-checkpoint-duckdb,
  langgraph-checkpoint-postgres,
  langgraph-checkpoint-sqlite,
  langsmith,
  psycopg,
  psycopg-pool,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytest-repeat,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
  postgresql,
  postgresqlTestHook,
}:
let
  # langgraph-prebuilt isn't meant to be a standalone package but is bundled into langgraph at build time.
  # It exists so the langgraph team can iterate on it without having to rebuild langgraph.
  langgraph-prebuilt = buildPythonPackage rec {
    pname = "langgraph-prebuilt";
    version = "0.1.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "langchain-ai";
      repo = "langgraph";
      tag = "prebuilt==${version}";
      hash = "sha256-Kyyr4BSrUReC6jBp4LItuS/JNSzGK5IUaPl7UaLse78=";
    };

    sourceRoot = "${src.name}/libs/prebuilt";

    build-system = [ poetry-core ];

    dependencies = [
      langchain-core
      langgraph-checkpoint
    ];

    skipPythonImportsCheck = true; # This will be packaged with langgraph

    # postgresql doesn't play nicely with the darwin sandbox:
    # FATAL:  could not create shared memory segment: Operation not permitted
    doCheck = !stdenv.hostPlatform.isDarwin;

    nativeCheckInputs = [
      pytestCheckHook
      postgresql
      postgresqlTestHook
    ];

    checkInputs = [
      langgraph-checkpoint
      langgraph-checkpoint-postgres
      langgraph-checkpoint-sqlite
      psycopg
      psycopg-pool
      pytest-asyncio
      pytest-mock
    ];

    preCheck = ''
      export PYTHONPATH=${src}/libs/langgraph:$PYTHONPATH
    '';

    pytestFlagsArray = [
      "-W"
      "ignore::pytest.PytestDeprecationWarning"
      "-W"
      "ignore::DeprecationWarning"
    ];

    disabledTestPaths = [
      # psycopg.OperationalError: connection failed: connection to server at "127.0.0.1", port 5442 failed: Connection refused
      # Is the server running on that host and accepting TCP/IP connections?
      "tests/test_react_agent.py"
    ];
  };
in
buildPythonPackage rec {
  pname = "langgraph";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "${version}";
    hash = "sha256-EawVIzG+db2k6/tQyUHCF6SzlO77QTXsYRUm3XpLu/c=";
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
    langgraph-checkpoint-duckdb
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
  ];

  disabledTestPaths = [
    # psycopg.errors.InsufficientPrivilege: permission denied to create database
    "tests/test_pregel_async.py"
    "tests/test_pregel.py"
    "tests/test_large_cases.py"
    "tests/test_large_cases_async.py"
  ];

  passthru = {
    inherit (langgraph-sdk) updateScript;
    skipBulkUpdate = true; # Broken, see https://github.com/NixOS/nixpkgs/issues/379898
  };

  meta = {
    description = "Build resilient language agents as graphs";
    homepage = "https://github.com/langchain-ai/langgraph";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
