{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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
  pymongo-search-utils,

  # test
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

buildPythonPackage (finalAttrs: {
  pname = "langchain-mongodb";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mongodb";
    tag = "libs/langchain-mongodb/v${finalAttrs.version}";
    hash = "sha256-dO0dASjyNMxnbxZ/ry8lcJxedPdrv6coYiTjOcaT8/0=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/langchain-mongodb";

  build-system = [ hatchling ];

  dependencies = [
    langchain
    langchain-classic
    langchain-core
    langchain-text-splitters
    numpy
    pymongo
    pymongo-search-utils
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

  pytestFlags = [
    # DeprecationWarning: 'asyncio.get_event_loop_policy' is deprecated
    "-Wignore::DeprecationWarning"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # UserWarning: Core Pydantic V1 functionality isn't compatible with Python 3.14
    "-Wignore::UserWarning"
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
    changelog = "https://github.com/langchain-ai/langchain-mongodb/releases/tag/${finalAttrs.src.tag}";
    description = "Integration package connecting MongoDB and LangChain";
    homepage = "https://github.com/langchain-ai/langchain-mongodb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
})
