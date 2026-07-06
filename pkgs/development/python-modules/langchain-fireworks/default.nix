{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  fireworks-ai,
  langchain-core,
  openai,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-fireworks";
  version = "1.4.3";
  pyproject = true;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-fireworks==${finalAttrs.version}";
    hash = "sha256-Z8KwSMq4kVCUVD9Cs8PU6ZRcC9ZG52dbeQrpYInt9L0=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/partners/fireworks";

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    fireworks-ai
    langchain-core
    openai
    pydantic
  ];

  pythonRelaxDeps = [
    "fireworks-ai"
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # Fails when langchain-core gets ahead of this package
    "test_serdes"
  ];

  pythonImportsCheck = [ "langchain_fireworks" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-fireworks==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "Build LangChain applications with Fireworks";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/fireworks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
})
