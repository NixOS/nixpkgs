{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  llama-index-llms-openai,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-llms-openai-like";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_llms_openai_like";
    inherit (finalAttrs) version;
    hash = "sha256-aTjP7WLHeHa6Q/JlGaq/VVd1/Y4Ofhry3fN6n8kdyjI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    llama-index-llms-openai
    transformers
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.openai_like" ];

  meta = {
    description = "LlamaIndex LLMS Integration for OpenAI like";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-openai-like";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
