{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  ollama,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-ollama";
<<<<<<< HEAD
  version = "0.8.5";
=======
  version = "0.8.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_embeddings_ollama";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-UYS3L2RjEJodPF1y6s/4CESde8GRqVmhlrlHHASWh7g=";
=======
    hash = "sha256-bahglDEI13W04ZFFCND2Vnht0BcKakU+CX7iuMKf6yA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "ollama" ];

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    ollama
    pytest-asyncio
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.embeddings.ollama" ];

<<<<<<< HEAD
  meta = {
    description = "LlamaIndex Llms Integration for Ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "LlamaIndex Llms Integration for Ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
