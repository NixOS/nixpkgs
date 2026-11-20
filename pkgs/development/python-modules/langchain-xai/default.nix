{
  lib,
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
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-xai==${finalAttrs.version}";
    hash = "sha256-VRH+ugYi2tQVdl8/c5LR97PxEK85qr7DqXuGGPrSzvY=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/partners/xai";

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "langchain-core" ];

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
      ignoredVersions = "a|b|dev|rc";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "Build LangChain applications with X AI";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/xai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
})
