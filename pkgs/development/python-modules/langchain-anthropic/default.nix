{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,

  # build-system
  pdm-backend,

  # dependencies
  anthropic,
  langchain-core,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-anthropic";
  version = "0.3.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-anthropic==${version}";
    hash = "sha256-GOD6pMuUDCfrQ6MP+/HXZIg5wHUDRysosEjXjewY/9M=";
  };

  sourceRoot = "${src.name}/libs/partners/anthropic";

  build-system = [ pdm-backend ];

  dependencies = [
    anthropic
    langchain-core
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

  disabledTestPaths = [
    "tests/integration_tests"
  ];

  pythonImportsCheck = [ "langchain_anthropic" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-anthropic==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-anthropic/releases/tag/${src.tag}";
    description = "Build LangChain applications with Anthropic";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/anthropic";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
