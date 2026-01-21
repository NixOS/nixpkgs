{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langgraph-checkpoint,
  langchain-mongodb,
}:

buildPythonPackage rec {
  pname = "langgraph-store-mongodb";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mongodb";
    tag = "libs/langchain-mongodb/v${version}";
    hash = "sha256-dO0dASjyNMxnbxZ/ry8lcJxedPdrv6coYiTjOcaT8/0=";
  };

  sourceRoot = "${src.name}/libs/langgraph-store-mongodb";

  build-system = [
    hatchling
  ];

  dependencies = [
    langgraph-checkpoint
    langchain-mongodb
  ];

  # Connection Refused (to mongodb://localhost:27017)
  # Note that `langchain-mongodb` runs the same tests with mocks.
  doCheck = false;

  pythonImportsCheck = [ "langgraph.store.mongodb" ];

  meta = {
    description = "Integrations between MongoDB, Atlas, LangChain, and LangGraph";
    homepage = "https://github.com/langchain-ai/langchain-mongodb/tree/main/libs/langgraph-store-mongodb";
    changelog = "https://github.com/langchain-ai/langchain-mongodb/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
