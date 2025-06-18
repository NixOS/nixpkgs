{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  poetry-core,

  # dependencies
  langchain-core,
  msgpack,
  ormsgpack,

  # testing
  dataclasses-json,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint";
  version = "2.0.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-DSkjaxUfpsOg2ex0dgfO/UJ7WiQb5wQsAGgHPTckF6o=";
  };

  sourceRoot = "${src.name}/libs/checkpoint";

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    ormsgpack
  ];

  propagatedBuildInputs = [ msgpack ];

  pythonImportsCheck = [ "langgraph.checkpoint" ];

  nativeCheckInputs = [
    dataclasses-json
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "checkpoint==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${src.tag}";
    description = "Library with base interfaces for LangGraph checkpoint savers";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
