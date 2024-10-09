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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-text-splitters==${version}";
    hash = "sha256-Z0UAUhOjC0wgCY/f1aWsnjFyOPYz/6JnloEKT6b6Ii0=";
  };

  sourceRoot = "${src.name}/libs/text-splitters";

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
  ];

  pythonImportsCheck = [ "langchain_text_splitters" ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-text-splitters==${version}";
    description = "LangChain utilities for splitting into chunks a wide variety of text documents";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
