{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,

  # tests
  httpx,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-text-splitters==${version}";
    hash = "sha256-2IoNUixZ/+o6ONJpqFa3Z5CLpxj6b6z8dh89kxh2rP4=";
  };

  sourceRoot = "${src.name}/libs/text-splitters";

  build-system = [ poetry-core ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langchain_text_splitters" ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  passthru = {
    inherit (langchain-core) updateScript;
    # updates the wrong fetcher rev attribute
    skipBulkUpdate = true;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-text-splitters==${version}";
    description = "LangChain utilities for splitting into chunks a wide variety of text documents";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
  };
}
