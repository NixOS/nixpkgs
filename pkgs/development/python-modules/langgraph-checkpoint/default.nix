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
  pycryptodome,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  redis,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langgraph-checkpoint";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${finalAttrs.version}";
    hash = "sha256-sSk8M78cAnPSbgZ/RcLSfbeFYu9+4m5qp5E6cv8W7qw=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/checkpoint";

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
    pycryptodome
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
      ignoredVersions = "a|b|dev|rc";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${finalAttrs.src.tag}";
    description = "Library with base interfaces for LangGraph checkpoint savers";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
})
