{
  lib,
  accelerate,
  buildPythonPackage,
  docling-core,
  docling-slim,
  fetchFromGitHub,
  hatchling,
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

buildPythonPackage (finalAttrs: {
  pname = "docling-mcp";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3xSk9EvRPS508bOpxiyLNAsysp7+58AIFiMB64fzkqA=";
  };

  pythonRemoveDeps = [
    # Disabled due to circular dependency
    "mellea"
  ];

  build-system = [ hatchling ];

  dependencies = [
    docling-core
    docling-slim
    mcp
    pydantic
    pydantic-settings
    python-dotenv
  ]
  ++ docling-slim.optional-dependencies.service-client
  ++ mcp.optional-dependencies.cli;

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
    local = docling-slim.optional-dependencies.standard;
    smolagents = [
      accelerate
      ollama
      smolagents
      torch
      transformers
    ]
    ++ smolagents.optional-dependencies.litellm
    ++ smolagents.optional-dependencies.mcp;
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.local;

  pythonImportsCheck = [ "docling_mcp" ];

  meta = {
    description = "Making docling agentic through MCP";
    homepage = "https://github.com/docling-project/docling-mcp";
    changelog = "https://github.com/docling-project/docling-mcp/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
