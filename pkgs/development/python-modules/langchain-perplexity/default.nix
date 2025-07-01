{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  openai,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-perplexity";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-perplexity==${version}";
    hash = "sha256-s20AnDsyLCzpG45QqgZp0WzlbdVrHNfpUQsMPUaF1qs=";
  };

  sourceRoot = "${src.name}/libs/partners/perplexity";

  build-system = [ pdm-backend ];

  dependencies = [
    langchain-core
    openai
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_perplexity" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-perplexity==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-perplexity/releases/tag/${src.tag}";
    description = "Build LangChain applications with Perplexity";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/perplexity";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
