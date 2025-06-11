{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

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

buildPythonPackage rec {
  pname = "langchain-xai";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-xai==${version}";
    hash = "sha256-9pSwEHqh+WkHsjn7JNsyEy+U67ekTqAdHMAvAFanR8w=";
  };

  sourceRoot = "${src.name}/libs/partners/xai";

  build-system = [ pdm-backend ];

  dependencies = [
    aiohttp
    langchain-core
    langchain-openai
    requests
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_xai" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-xai==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-xai/releases/tag/${src.tag}";
    description = "Build LangChain applications with X AI";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/xai";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
