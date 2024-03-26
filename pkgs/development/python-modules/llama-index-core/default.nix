{ lib
, aiohttp
, buildPythonPackage
, dataclasses-json
, deprecated
, dirtyjson
, fetchFromGitHub
, fsspec
, llamaindex-py-client
, nest-asyncio
, networkx
, nltk
, numpy
, openai
, pandas
, pillow
, poetry-core
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, tree-sitter
, sqlalchemy
, tenacity
, tiktoken
, typing-inspect
}:

buildPythonPackage rec {
  pname = "llama-index-core";
  version = "0.10.23";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_index";
    rev = "refs/tags/v${version}";
    hash = "sha256-koFdHpcMX4Qg+LLDcjHx4wYxHnrJaAqebpba0ejINzo=";
  };

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    dataclasses-json
    deprecated
    dirtyjson
    fsspec
    llamaindex-py-client
    nest-asyncio
    networkx
    nltk
    numpy
    openai
    pandas
    pillow
    pyyaml
    requests
    sqlalchemy
    tenacity
    tiktoken
    typing-inspect
  ];

  nativeCheckInputs = [
    tree-sitter
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llama_index"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/agent/"
    "tests/callbacks/"
    "tests/chat_engine/"
    "tests/evaluation/"
    "tests/indices/"
    "tests/ingestion/"
    "tests/memory/"
    "tests/node_parser/"
    "tests/objects/"
    "tests/playground/"
    "tests/postprocessor/"
    "tests/query_engine/"
    "tests/question_gen/"
    "tests/response_synthesizers/"
    "tests/retrievers/"
    "tests/selectors/"
    "tests/test_utils.py"
    "tests/text_splitter/"
    "tests/token_predictor/"
    "tests/tools/"
  ];

  meta = with lib; {
    description = "Data framework for your LLM applications";
    homepage = "https://github.com/run-llama/llama_index/";
    changelog = "https://github.com/run-llama/llama_index/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
