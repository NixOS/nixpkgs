{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,

  # tests
  beautifulsoup4,
  httpx,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-text-splitters";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-text-splitters==${finalAttrs.version}";
    hash = "sha256-AiRl8N2V2UfYLZfqxM8DHZmT76rH19I1gFyOYc/mpYY=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/text-splitters";

  build-system = [ hatchling ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langchain_text_splitters" ];

  nativeCheckInputs = [
    beautifulsoup4
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
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${finalAttrs.src.tag}";
    description = "LangChain utilities for splitting into chunks a wide variety of text documents";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
  };
})
