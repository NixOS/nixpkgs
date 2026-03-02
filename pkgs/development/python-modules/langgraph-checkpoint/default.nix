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
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-IE9Y+kFkDN49SuwvTNwa2kK+Hig18sJPZmZCqHUP3DM=";
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
