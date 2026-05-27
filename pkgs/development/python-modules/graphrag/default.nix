{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiofiles,
  azure-cosmos,
  azure-identity,
  azure-search-documents,
  azure-storage-blob,
  devtools,
  environs,
  fnllm,
  future,
  graspologic,
  json-repair,
  lancedb,
  litellm,
  networkx,
  nltk,
  numpy,
  openai,
  pandas,
  pyarrow,
  pydantic,
  python-dotenv,
  pyyaml,
  spacy,
  textblob,
  tiktoken,
  tqdm,
  typer,
  typing-extensions,
  umap-learn,

  # tests
  nbformat,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphrag";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graphrag";
    tag = "v${version}";
    hash = "sha256-F0MiC+14KOjCVwlcZpNo15SqDOfSYsVwH8qNQTHBKPQ=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = true;

  dependencies = [
    aiofiles
    azure-cosmos
    azure-identity
    azure-search-documents
    azure-storage-blob
    devtools
    environs
    fnllm
    future
    graspologic
    json-repair
    lancedb
    litellm
    networkx
    nltk
    numpy
    openai
    pandas
    pyarrow
    pydantic
    python-dotenv
    pyyaml
    spacy
    textblob
    tiktoken
    tqdm
    typer
    typing-extensions
    umap-learn
  ]
  ++ fnllm.optional-dependencies.azure
  ++ fnllm.optional-dependencies.openai;

  env.NUMBA_CACHE_DIR = "$TMPDIR";

  pythonImportsCheck = [ "graphrag" ];

  nativeCheckInputs = [
    nbformat
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky
    "tests/unit/litellm_services/test_rate_limiter.py"
  ];

  disabledTests = [
    # touch the network
    "test_basic_functionality"
    "test_child"
    "test_dotprefix"
    "test_find"
    "test_load_strategy_sentence"
    "test_mixed_whitespace_handling"
    "test_multiple_documents"
    "test_run_extract_entities_multiple_documents"
    "test_run_extract_entities_single_document"
    "test_sort_context"
    "test_sort_context_max_tokens"
  ];

  meta = {
    description = "Modular graph-based Retrieval-Augmented Generation (RAG) system";
    homepage = "https://github.com/microsoft/graphrag";
    changelog = "https://github.com/microsoft/graphrag/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
