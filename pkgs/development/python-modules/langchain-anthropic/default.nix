{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anthropic,
  langchain-core,
  pydantic,

  # tests
  blockbuster,
  langchain,
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-anthropic";
  version = "1.4.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-anthropic==${finalAttrs.version}";
    hash = "sha256-MX+DhFEkRNZ3IEKMXFT61XR6hEx2WPdGGaA0b/KlPZE=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/partners/anthropic";

  build-system = [ hatchling ];

  # Langchain always tracks the latest release of anthropic whether or not it's needed
  pythonRelaxDeps = [ "anthropic" ];

  dependencies = [
    anthropic
    langchain-core
    pydantic
  ];

  nativeCheckInputs = [
    blockbuster
    langchain
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/unit_tests"
  ];

  disabledTests = [
    # Fails when langchain-core gets ahead of this
    "test_serdes"
    # KeyError: 'versions' in 1.4.6
    "test_anthropic_model_params"
  ];

  pythonImportsCheck = [ "langchain_anthropic" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-anthropic==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "Build LangChain applications with Anthropic";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/anthropic";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
})
