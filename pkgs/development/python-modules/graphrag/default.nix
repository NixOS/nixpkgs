{
  lib,
<<<<<<< HEAD
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
=======
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  aiofiles,
  aiolimiter,
  azure-identity,
  azure-search-documents,
  azure-storage-blob,
  datashaper,
  devtools,
  environs,
  fnllm,
  graspologic,
  json-repair,
  lancedb,
  matplotlib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  networkx,
  nltk,
  numpy,
  openai,
  pandas,
<<<<<<< HEAD
=======
  pyaml-env,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyarrow,
  pydantic,
  python-dotenv,
  pyyaml,
<<<<<<< HEAD
  spacy,
  textblob,
  tiktoken,
  tqdm,
  typer,
  typing-extensions,
  umap-learn,

  # tests
=======
  rich,
  tenacity,
  tiktoken,
  typer,
  typing-extensions,
  umap-learn,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nbformat,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphrag";
<<<<<<< HEAD
  version = "2.7.0";
=======
  version = "2.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graphrag";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-F0MiC+14KOjCVwlcZpNo15SqDOfSYsVwH8qNQTHBKPQ=";
  };

  build-system = [
    setuptools
=======
    tag = "v.${version}";
    hash = "sha256-a8t6Nl9W/Cr7eueAvJ3dbz5G0oIhddqFMIm7HeZ8N9A=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonRelaxDeps = true;

  dependencies = [
    aiofiles
<<<<<<< HEAD
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
=======
    aiolimiter
    azure-identity
    azure-search-documents
    azure-storage-blob
    datashaper
    devtools
    environs
    fnllm
    graspologic
    json-repair
    lancedb
    matplotlib
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    networkx
    nltk
    numpy
    openai
    pandas
<<<<<<< HEAD
=======
    pyaml-env
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pyarrow
    pydantic
    python-dotenv
    pyyaml
<<<<<<< HEAD
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
=======
    rich
    tenacity
    tiktoken
    typer
    typing-extensions
    umap-learn
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.NUMBA_CACHE_DIR = "$TMPDIR";

  pythonImportsCheck = [ "graphrag" ];

  nativeCheckInputs = [
    nbformat
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

<<<<<<< HEAD
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
=======
  disabledTests = [
    # touch the network
    "test_child"
    "test_dotprefix"
    "test_find"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
