{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  langchain-openai,

  # testing
  langchain-tests,
  pytestCheckHook,
  pytest-asyncio,
  syrupy,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-deepseek";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-deepseek==${version}";
    hash = "sha256-nkL8QO1H29sA6g61Hgt7QrRAfwD3t+0m5JEHyPx8B7Y=";
  };

  sourceRoot = "${src.name}/libs/partners/deepseek";

  build-system = [
    pdm-backend
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    langchain-core
    langchain-openai
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
    pytest-asyncio
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_deepseek" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-deepseek==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting DeepSeek and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/deepseek";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
