{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

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

buildPythonPackage rec {
  pname = "langchain-fireworks";
  version = "0.3.72";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-Q2uGMiODUtwkPdOyuSqp8vqjlLjiXk75QjXp7rr20tc=";
  };

  sourceRoot = "${src.name}/libs/partners/fireworks";

  build-system = [ pdm-backend ];

  dependencies = [
    aiohttp
    fireworks-ai
    langchain-core
    openai
    pydantic
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_fireworks" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-fireworks==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Build LangChain applications with Fireworks";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/fireworks";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
