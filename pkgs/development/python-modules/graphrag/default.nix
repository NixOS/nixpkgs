{
  lib,
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
  networkx,
  nltk,
  numpy,
  openai,
  pandas,
  pyaml-env,
  pyarrow,
  pydantic,
  python-dotenv,
  pyyaml,
  rich,
  tenacity,
  tiktoken,
  typer,
  typing-extensions,
  umap-learn,
  nbformat,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphrag";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graphrag";
    tag = "v.${version}";
    hash = "sha256-a8t6Nl9W/Cr7eueAvJ3dbz5G0oIhddqFMIm7HeZ8N9A=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  pythonRelaxDeps = true;

  dependencies = [
    aiofiles
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
    networkx
    nltk
    numpy
    openai
    pandas
    pyaml-env
    pyarrow
    pydantic
    python-dotenv
    pyyaml
    rich
    tenacity
    tiktoken
    typer
    typing-extensions
    umap-learn
  ];

  env.NUMBA_CACHE_DIR = "$TMPDIR";

  pythonImportsCheck = [ "graphrag" ];

  nativeCheckInputs = [
    nbformat
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTests = [
    # touch the network
    "test_child"
    "test_dotprefix"
    "test_find"
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
