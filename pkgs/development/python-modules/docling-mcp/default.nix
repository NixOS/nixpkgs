{
  lib,
  accelerate,
  buildPythonPackage,
  docling,
  fetchFromGitHub,
  hatchling,
  httpx,
  llama-index-core,
  llama-index-embeddings-huggingface,
  llama-index-embeddings-openai,
  llama-index-llms-openai-like,
  llama-index-node-parser-docling,
  llama-index-readers-docling,
  llama-index-readers-file,
  llama-index-vector-stores-milvus,
  llama-index,
  llama-stack-client,
  mcp,
  ollama,
  pydantic-settings,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  smolagents,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "docling-mcp";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-mcp";
    tag = "v${version}";
    hash = "sha256-MEGj/tPHDZqvgqmzXsoeEIWWU7vlLo8H4KhMFgf6q2c=";
  };

  pythonRemoveDeps = [
    # Disabled due to circular dependency
    "mellea"
  ];

  build-system = [ hatchling ];

  dependencies = [
    docling
    httpx
    mcp
    pydantic
    pydantic-settings
    python-dotenv
  ];

  optional-dependencies = {
    llama-index-rag = [
      llama-index
      llama-index-core
      llama-index-embeddings-huggingface
      llama-index-embeddings-openai
      llama-index-llms-openai-like
      llama-index-node-parser-docling
      llama-index-readers-docling
      llama-index-readers-file
      llama-index-vector-stores-milvus
    ];
    llama-stack = [ llama-stack-client ];
    smolagents = [
      accelerate
      ollama
      smolagents
      torch
      transformers
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "docling_mcp" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_mcp_server.py"
    "tests/test_conversion_tools.py"
  ];

  meta = {
    description = "Making docling agentic through MCP";
    homepage = "https://github.com/docling-project/docling-mcp";
    changelog = "https://github.com/docling-project/docling-mcp/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
