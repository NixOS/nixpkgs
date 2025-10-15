{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,

  # tests
  httpx,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-text-splitters==${version}";
    hash = "sha256-SShVzssXi18j5gcDSwwDT+umObEk7uhaCP2mMolQJxI=";
  };

  sourceRoot = "${src.name}/libs/text-splitters";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langchain_text_splitters" ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-text-splitters==";
      ignoredVersions = "[0-9]+\.?(a|dev|rc)[0-9]+$";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "LangChain utilities for splitting into chunks a wide variety of text documents";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
  };
}
