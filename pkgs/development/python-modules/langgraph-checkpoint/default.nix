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

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-UY3AChShKfOrtOQzOm5vi3Yy3rlBc+TAje9L2L6My/U=";
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
  ];

  disabledTests = [
    # assert 1.0000000000000004 == 1.0000000000000002
    # https://github.com/langchain-ai/langgraph/issues/5845
    "test_embed_with_path"
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
