{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  openai,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-llms-openai";
  version = "0.6.15";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_llms_openai";
    inherit (finalAttrs) version;
    hash = "sha256-W9BZ6kRBLpJ3Q6mLseW4Sy4ZS7OW75WVJ/w6isgLAl0=";
  };

  pythonRemoveDeps = [
    # Circular dependency
    "llama-index-agent-openai"
  ];

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    openai
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.openai" ];

  meta = {
    description = "LlamaIndex LLMS Integration for OpenAI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
