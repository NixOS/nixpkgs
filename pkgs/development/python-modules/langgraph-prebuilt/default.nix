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

  # tests
  langgraph-checkpoint-postgres,
  langgraph-checkpoint-sqlite,
  langgraph-sdk,
  postgresql,
  postgresqlTestHook,
  psycopg,
  psycopg-pool,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  syrupy,
  xxhash,

  # passthru
  gitUpdater,
}:
# langgraph-prebuilt isn't meant to be a standalone package but is bundled into langgraph at build time.
# It exists so the langgraph team can iterate on it without having to rebuild langgraph.
buildPythonPackage (finalAttrs: {
  pname = "langgraph-prebuilt";
  version = "1.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "prebuilt==${finalAttrs.version}";
    hash = "sha256-B9ntvj6qoKd63W/cPkevtfHbv8XUxmkaWupxURA8C68=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/prebuilt";

  build-system = [ hatchling ];

  dependencies = [
    langchain-core
    langgraph-checkpoint
    langgraph-sdk
  ];

  skipPythonImportsCheck = true; # This will be packaged with langgraph

  # postgresql doesn't play nicely with the darwin sandbox:
  # FATAL:  could not create shared memory segment: Operation not permitted
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    langgraph-checkpoint
    langgraph-checkpoint-postgres
    langgraph-checkpoint-sqlite
    postgresql
    postgresqlTestHook
    psycopg
    psycopg-pool
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    syrupy
    xxhash
  ];

  preCheck = ''
    export PYTHONPATH=${finalAttrs.src}/libs/langgraph:$PYTHONPATH
  '';

  pytestFlags = [
    "-Wignore::pytest.PytestDeprecationWarning"
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # psycopg.OperationalError: connection failed: connection to server at "127.0.0.1", port 5442 failed: Connection refused
    # Is the server running on that host and accepting TCP/IP connections?
    "tests/test_react_agent.py"

    # Utilities to import
    "tests/conftest.py"
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "prebuilt==";
    };
  };

  meta = {
    description = "Prebuilt agents add-on for Langgraph. Should always be bundled with langgraph";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/prebuilt";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
