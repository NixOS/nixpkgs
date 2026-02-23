{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,

  # build-system
  hatchling,

  # dependencies
  langgraph-checkpoint,
  langchain-mongodb,
  pymongo,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-mongodb";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mongodb";
    tag = "libs/langgraph-checkpoint-mongodb/v${version}";
    hash = "sha256-vCiZ6Mp6aHmSEkLbeM6qTLJaxH0uoAdq80olTT5saX0=";
  };

  sourceRoot = "${src.name}/libs/langgraph-checkpoint-mongodb";

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "pymongo"
  ];

  dependencies = [
    langgraph-checkpoint
    langchain-mongodb
    pymongo
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  # Connection refused (to localhost:27017) for all tests
  doCheck = false;

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "libs/langgraph-checkpoint-mongodb/v";
    };
  };

  # no pythonImportsCheck as this package does not provide any direct imports
  pythonImportsCheck = [ "langgraph.checkpoint.mongodb" ];

  meta = {
    description = "Integrations between MongoDB, Atlas, LangChain, and LangGraph";
    homepage = "https://github.com/langchain-ai/langchain-mongodb/tree/main/libs/langgraph-checkpoint-mongodb";
    changelog = "https://github.com/langchain-ai/langchain-mongodb/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
