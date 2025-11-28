{
  lib,
  aiohttp,
  aiosqlite,
  banks,
  buildPythonPackage,
  dataclasses-json,
  deprecated,
  dirtyjson,
  fetchFromGitHub,
  filetype,
  fsspec,
  hatchling,
  jsonpath-ng,
  llama-index-workflows,
  llamaindex-py-client,
  nest-asyncio,
  networkx,
  nltk-data,
  nltk,
  numpy,
  openai,
  pandas,
  pillow,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  pyvis,
  pyyaml,
  requests,
  spacy,
  sqlalchemy,
  tenacity,
  tiktoken,
  tree-sitter,
  typing-inspect,
}:

buildPythonPackage rec {
  pname = "llama-index-core";
  version = "0.14.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_index";
    tag = "v${version}";
    hash = "sha256-wjw2XTRK1qjfNzndC7q197rU8PVtD8SI7FR4Skary+E=";
  };

  sourceRoot = "${src.name}/${pname}";

  # When `llama-index` is imported, it uses `nltk` to look for the following files and tries to
  # download them if they aren't present.
  # https://github.com/run-llama/llama_index/blob/6efa53cebd5c8ccf363582c932fffde44d61332e/llama-index-core/llama_index/core/utils.py#L59-L67
  # Setting `NLTK_DATA` to a writable path can also solve this problem, but it needs to be done in
  # every package that depends on `llama-index-core` for `pythonImportsCheck` not to fail, so this
  # solution seems more elegant.
  postPatch = ''
    mkdir -p llama_index/core/_static/nltk_cache/corpora/stopwords/
    cp -r ${nltk-data.stopwords}/corpora/stopwords/* llama_index/core/_static/nltk_cache/corpora/stopwords/

    mkdir -p llama_index/core/_static/nltk_cache/tokenizers/punkt/
    cp -r ${nltk-data.punkt}/tokenizers/punkt/* llama_index/core/_static/nltk_cache/tokenizers/punkt/
  '';

  pythonRelaxDeps = [
    "setuptools"
    "tenacity"
  ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiosqlite
    banks
    dataclasses-json
    deprecated
    dirtyjson
    filetype
    fsspec
    jsonpath-ng
    llama-index-workflows
    llamaindex-py-client
    nest-asyncio
    networkx
    nltk
    numpy
    openai
    pandas
    pillow
    pyvis
    pyyaml
    requests
    spacy
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
    "tests/schema/"
    "tests/multi_modal_llms/"
  ];

  disabledTests = [
    # Tests require network access
    "test_context_extraction_basic"
    "test_context_extraction_custom_prompt"
    "test_context_extraction_oversized_document"
    "test_document_block_from_b64"
    "test_document_block_from_bytes"
    "test_document_block_from_path"
    "test_document_block_from_url"
    "test_from_namespaced_persist_dir"
    "test_from_persist_dir"
    "test_mimetype_raw_data"
    "test_multiple_documents_context"
    "test_predict_and_call_via_react_agent"
    "test_resource"
    # asyncio.exceptions.InvalidStateError: invalid state
    "test_workflow_context_to_dict_mid_run"
    "test_SimpleDirectoryReader"
    # RuntimeError
    "test_str"
  ];

  meta = with lib; {
    description = "Data framework for your LLM applications";
    homepage = "https://github.com/run-llama/llama_index/";
    changelog = "https://github.com/run-llama/llama_index/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
