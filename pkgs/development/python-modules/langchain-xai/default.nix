{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  langchain-core,
  langchain-openai,
  requests,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-xai";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-xai==${finalAttrs.version}";
    hash = "sha256-RUklm627HiwMcpKkm+0uWZgHp4iDtSsmEpLb9MxumqI=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/partners/xai";

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    langchain-core
    langchain-openai
    requests
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # Breaks when langchain-core is updated
    # Also: Compares a diff to a string literal and misses platform differences (aarch64-linux)
    "test_serdes"
  ];

  pythonImportsCheck = [ "langchain_xai" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-xai==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-xai/releases/tag/${finalAttrs.src.tag}";
    description = "Build LangChain applications with X AI";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/xai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
})
