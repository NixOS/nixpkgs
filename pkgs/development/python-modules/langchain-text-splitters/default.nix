{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  langchain-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-text-splitters==${version}";
    hash = "sha256-SixF3ZkN+gjQ4KYLhGoezdQAOQ1AlGEC6IBzHePF6/o=";
  };

  sourceRoot = "${src.name}/libs/text-splitters";

  build-system = [ poetry-core ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langchain_text_splitters" ];

  nativeCheckInputs = [
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
