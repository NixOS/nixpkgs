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
  fastparquet,
  graspologic,
  json-repair,
  lancedb,
  networkx,
  nltk,
  numba,
  numpy,
  openai,
  pyaml-env,
  pydantic,
  python-dotenv,
  pyyaml,
  rich,
  scipy,
  swifter,
  tenacity,
  textual,
  tiktoken,
  typing-extensions,
  uvloop,
  nbformat,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graphrag";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "graphrag";
    rev = "refs/tags/v${version}";
    hash = "sha256-97X9a3ietWDc5UgdgQ2ZSc7DPDEi96LxfO5aVZMNOfg=";
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
    fastparquet
    graspologic
    json-repair
    lancedb
    networkx
    nltk
    numba
    numpy
    openai
    pyaml-env
    pydantic
    python-dotenv
    pyyaml
    rich
    scipy
    swifter
    tenacity
    textual
    tiktoken
    typing-extensions
    uvloop
  ];

  env.NUMBA_CACHE_DIR = "$TMPDIR";

  pythonImportsCheck = [ "graphrag" ];

  nativeCheckInputs = [
    nbformat
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # touch the network
    "test_child"
    "test_dotprefix"
    "test_find"
    "test_run_extract_entities_multiple_documents"
    "test_run_extract_entities_single_document"
    "test_sort_context_max_tokens"
  ];

  meta = {
    description = "Modular graph-based Retrieval-Augmented Generation (RAG) system";
    homepage = "https://github.com/microsoft/graphrag";
    changelog = "https://github.com/microsoft/graphrag/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
