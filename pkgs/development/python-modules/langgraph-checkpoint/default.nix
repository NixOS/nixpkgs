{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  hatchling,

  # dependencies
  langchain-core,
  msgpack,
  ormsgpack,

  # testing
  dataclasses-json,
  numpy,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  redis,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-3hh1KyEIsp9JzhaJW1ycp179FGpggPYzg6OwnD/cTBM=";
  };

  sourceRoot = "${src.name}/libs/checkpoint";

  build-system = [ hatchling ];

  dependencies = [
    langchain-core
    ormsgpack
  ];

  propagatedBuildInputs = [ msgpack ];

  pythonImportsCheck = [ "langgraph.checkpoint" ];

  nativeCheckInputs = [
    dataclasses-json
    numpy
    pandas
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    redis
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "checkpoint==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    description = "Library with base interfaces for LangGraph checkpoint savers";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
}
