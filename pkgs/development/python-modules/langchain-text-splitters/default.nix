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
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-text-splitters==${version}";
    hash = "sha256-mYaIVE/v+t7TJw/l87IJcFh893OTIew6jl6OVj0gXCo=";
  };

  sourceRoot = "${src.name}/libs/text-splitters";

  build-system = [ pdm-backend ];

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
