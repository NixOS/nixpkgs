{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langgraph-checkpoint,
  langchain-mongodb,
  pymongo,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint-mongodb";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mongodb";
    tag = "libs/langgraph-checkpoint-mongodb/v${version}";
    hash = "sha256-pfgqJ7QPtAxV86HEEaRBMAOCKC8y/iTlZmPzu1szE/o=";
  };

  sourceRoot = "${src.name}/libs/langgraph-checkpoint-mongodb";

  build-system = [
    hatchling
  ];

  dependencies = [
    langgraph-checkpoint
    langchain-mongodb
    pymongo
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  # Connection refused (to localhost:27017) for all tests
  doCheck = false;

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
