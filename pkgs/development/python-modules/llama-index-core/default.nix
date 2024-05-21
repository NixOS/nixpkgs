{
  lib,
  aiohttp,
  buildPythonPackage,
  dataclasses-json,
  deprecated,
  dirtyjson,
  fetchFromGitHub,
  fetchzip,
  fsspec,
  llamaindex-py-client,
  nest-asyncio,
  networkx,
  nltk,
  numpy,
  openai,
  pandas,
  pillow,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  tree-sitter,
  sqlalchemy,
  tenacity,
  tiktoken,
  typing-inspect,
}:

let
  stopwords = fetchzip {
    url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/stopwords.zip";
    hash = "sha256-tX1CMxSvFjr0nnLxbbycaX/IBnzHFxljMZceX5zElPY=";
  };

  punkt = fetchzip {
    url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip";
    hash = "sha256-SKZu26K17qMUg7iCFZey0GTECUZ+sTTrF/pqeEgJCos=";
  };
in

buildPythonPackage rec {
  pname = "llama-index-core";
  version = "0.10.36";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_index";
    rev = "refs/tags/v${version}";
    hash = "sha256-yP/60DLg43UOOogxbDvb1p5n8dnfBUjGhcfO5g5g0gA=";
  };

  sourceRoot = "${src.name}/${pname}";

  # When `llama-index` is imported, it uses `nltk` to look for the following files and tries to
  # download them if they aren't present.
  # https://github.com/run-llama/llama_index/blob/6efa53cebd5c8ccf363582c932fffde44d61332e/llama-index-core/llama_index/core/utils.py#L59-L67
  # Setting `NLTK_DATA` to a writable path can also solve this problem, but it needs to be done in
  # every package that depends on `llama-index-core` for `pythonImportsCheck` not to fail, so this
  # solution seems more elegant.
  patchPhase = ''
    mkdir -p llama_index/core/_static/nltk_cache/corpora/stopwords/
    cp -r ${stopwords}/* llama_index/core/_static/nltk_cache/corpora/stopwords/

    mkdir -p llama_index/core/_static/nltk_cache/tokenizers/punkt/
    cp -r ${punkt}/* llama_index/core/_static/nltk_cache/tokenizers/punkt/
  '';

  build-system = [ poetry-core ];

  dependencies = [
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

  pythonImportsCheck = [ "llama_index" ];

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
