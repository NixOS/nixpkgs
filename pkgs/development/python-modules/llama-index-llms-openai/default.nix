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
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_llms_openai";
    inherit (finalAttrs) version;
    hash = "sha256-NnpHdp9jqfZi5uP6kCT/27Q0nXbWZ+zeTAaDYNzJ3oM=";
  };

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
