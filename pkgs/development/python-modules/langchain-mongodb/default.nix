{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain,
  langchain-classic,
  langchain-core,
  langchain-text-splitters,
  lark,
  numpy,
  pymongo,

  freezegun,
  httpx,
  langchain-community,
  langchain-ollama,
  langchain-openai,
  langchain-tests,
  mongomock,
  pytest-asyncio,
  pytestCheckHook,
  pytest-mock,
  syrupy,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-mongodb";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mongodb";
    tag = "libs/langchain-mongodb/v${version}";
    hash = "sha256-TpEiTQe4nZEhb7yWdm73oKaHGr58Ej3cNeD1sP5pAxA=";
  };

  sourceRoot = "${src.name}/libs/langchain-mongodb";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "numpy"
  ];

  dependencies = [
    langchain
    langchain-classic
    langchain-core
    langchain-text-splitters
    numpy
    pymongo
  ];

  nativeCheckInputs = [
    freezegun
    httpx
    langchain-community
    langchain-ollama
    langchain-openai
    langchain-tests
    lark
    mongomock
    pytest-asyncio
    pytestCheckHook
    pytest-mock
    syrupy
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTestPaths = [
    # Expects a MongoDB cluster and are very slow
    "tests/unit_tests/test_index.py"
  ];

  pythonImportsCheck = [ "langchain_mongodb" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "libs/langchain-mongodb/v";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-mongodb/releases/tag/${src.tag}";
    description = "Integration package connecting MongoDB and LangChain";
    homepage = "https://github.com/langchain-ai/langchain-mongodb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
