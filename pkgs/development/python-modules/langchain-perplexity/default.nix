{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

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
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-perplexity==${version}";
    hash = "sha256-bm7sIa62CIvsYNDdaN+XZKpRnCv5bg9kPZ1Ym8utFcM=";
  };

  sourceRoot = "${src.name}/libs/partners/perplexity";

  build-system = [ hatchling ];

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

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_perplexity" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-perplexity==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-perplexity/releases/tag/${src.tag}";
    description = "Build LangChain applications with Perplexity";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/perplexity";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
}
