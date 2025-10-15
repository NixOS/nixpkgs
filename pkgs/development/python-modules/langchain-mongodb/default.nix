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
    repo = "langchain";
    tag = "langchain-mongodb==${version}";
    hash = "sha256-Jd9toXkS9dGtSIrJQ/5W+swV1z2BJOJKBtkyGzj3oSc=";
  };

  sourceRoot = "${src.name}/libs/partners/mongodb";

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
      rev-prefix = "langchain-mongodb==";
      ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting MongoDB and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/mongodb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
