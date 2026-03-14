{
  buildPythonPackage,
  hatchling,
  llama-index-cli,
  llama-index-core,
  llama-index-embeddings-openai,
  llama-index-indices-managed-llama-cloud,
  llama-index-llms-openai,
  llama-index-readers-llama-parse,
  nltk,
}:

buildPythonPackage {
  pname = "llama-index";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "llama-index-core" ];

  dependencies = [
    llama-index-cli
    llama-index-core
    llama-index-embeddings-openai
    llama-index-indices-managed-llama-cloud
    llama-index-llms-openai
    llama-index-readers-llama-parse
    nltk
  ];

  pythonImportsCheck = [ "llama_index" ];
}
