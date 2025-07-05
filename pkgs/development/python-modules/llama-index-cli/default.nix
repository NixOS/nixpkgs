{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  llama-index-embeddings-openai,
  llama-index-llms-openai,
  llama-index-vector-stores-chroma,
}:

buildPythonPackage rec {
  pname = "llama-index-cli";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_cli";
    inherit version;
    hash = "sha256-2ugYOhBVG72JaGuU7SlKbPRGM8PdYoXE+ZHIUDG3pV8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    llama-index-embeddings-openai
    llama-index-llms-openai
    llama-index-vector-stores-chroma
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.cli" ];

  meta = with lib; {
    description = "LlamaIndex CLI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
