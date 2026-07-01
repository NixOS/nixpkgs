{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  ollama,

  # testing
  langchain-tests,
  pytestCheckHook,
  pytest-asyncio,
  pytest-socket,
  syrupy,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-ollama";
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-ollama==${finalAttrs.version}";
    hash = "sha256-4MbrfHf/ElBFR9cXIx+spQB+xsw2aj94IBJ5hcB6SJ0=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/partners/ollama";

  build-system = [
    hatchling
  ];

  dependencies = [
    langchain-core
    ollama
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
    pytest-asyncio
    pytest-socket
    syrupy
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  disabledTests = [
    # The expected shell can't spawn
    # test_standard_params_model_override - AssertionError: ls_model_name did not reflect the per-call `model` override...ZZ
    "test_standard_params_model_override"
  ];

  pythonImportsCheck = [ "langchain_ollama" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-ollama==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "Integration package connecting Ollama and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
