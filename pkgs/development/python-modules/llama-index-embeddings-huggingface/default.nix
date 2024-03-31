{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
, sentence-transformers
}:

buildPythonPackage rec {
  pname = "llama-index-embeddings-huggingface";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_embeddings_huggingface";
    inherit version;
    hash = "sha256-3PCplFXzfE4aL91c1lyd0aRRu4aMP4DDNcTQybadAHE=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
    sentence-transformers
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.embeddings.huggingface"
  ];

  meta = with lib; {
    description = "LlamaIndex Embeddings Integration for Huggingface";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-huggingface";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
