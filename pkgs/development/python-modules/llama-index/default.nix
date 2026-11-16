{
  buildPythonPackage,
  hatchling,
  llama-index-cli,
  llama-index-core,
  llama-index-embeddings-openai,
  llama-index-llms-openai,
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
    llama-index-llms-openai
    nltk
  ];

  pythonImportsCheck = [ "llama_index" ];
}
