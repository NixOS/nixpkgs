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
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-91q+U1KfE5eXm6jAd1PNZzZZgpTyNCaF1YVoHYwOrRA=";
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

  disabledTests = [
    # assert 1.0000000000000004 == 1.0000000000000002
    # https://github.com/langchain-ai/langgraph/issues/5845
    "test_embed_with_path"
  ];

  disabledTestPaths = [
    # psycopg.errors.FeatureNotSupported: extension "vector" is not available
    "tests/test_store.py::test_non_ascii[vector-cosine]"
    "tests/test_store.py::test_non_ascii[vector-inner_product]"
    "tests/test_store.py::test_non_ascii[halfvec-cosine]"
    "tests/test_store.py::test_non_ascii[halfvec-inner_product]"
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "checkpoint==";
      ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
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
