{
  buildPythonPackage,
  hatchling,
  llama-index-cli,
  llama-index-core,
  llama-index-embeddings-openai,
  llama-index-indices-managed-llama-cloud,
  llama-index-legacy,
  llama-index-llms-openai,
  llama-index-multi-modal-llms-openai,
  llama-index-readers-file,
  llama-index-readers-llama-parse,
}:

buildPythonPackage {
  pname = "llama-index";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "llama-index-core"
    "llama-index-multi-modal-llms-openai"
  ];

  dependencies = [
    llama-index-cli
    llama-index-core
    llama-index-embeddings-openai
    llama-index-indices-managed-llama-cloud
    llama-index-legacy
    llama-index-llms-openai
    llama-index-multi-modal-llms-openai
    llama-index-readers-file
    llama-index-readers-llama-parse
  ];

  pythonImportsCheck = [ "llama_index" ];
}
