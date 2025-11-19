{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  numpy,
  pymongo,

  freezegun,
  httpx,
  langchain,
  pytest-asyncio,
  pytestCheckHook,
  pytest-mock,
  syrupy,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-mongodb";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-mongodb";
    tag = "libs/langchain-mongodb/v${version}";
    hash = "sha256-Jd9toXkS9dGtSIrJQ/5W+swV1z2BJOJKBtkyGzj3oSc=";
  };

  sourceRoot = "${src.name}/libs/langchain-mongodb";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "numpy"
  ];

  dependencies = [
    langchain-core
    numpy
    pymongo
  ];

  nativeCheckInputs = [
    freezegun
    httpx
    langchain
    pytest-asyncio
    pytestCheckHook
    pytest-mock
    syrupy
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

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
