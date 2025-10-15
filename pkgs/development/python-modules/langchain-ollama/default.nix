{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  ollama,

  # testing
  langchain-tests,
  pytestCheckHook,
  pytest-asyncio,
  syrupy,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-ollama";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-ollama==${version}";
    hash = "sha256-DxqsnoiDk6wtUmIOvKK3RAAfDkMmV88HQeGB2udZcgA=";
  };

  sourceRoot = "${src.name}/libs/partners/ollama";

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
    ollama
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
    pytest-asyncio
    syrupy
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_ollama" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-ollama==";
      ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting Ollama and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
