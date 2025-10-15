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
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-deepseek==${version}";
    hash = "sha256-lIlThVpyZF5osiCyYMO8kQUNtG5eUjXGZLdgRraj4Yc=";
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

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_deepseek" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-deepseek==";
      ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting DeepSeek and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/deepseek";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
