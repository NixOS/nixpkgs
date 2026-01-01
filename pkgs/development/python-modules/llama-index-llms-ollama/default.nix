{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  ollama,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-ollama";
<<<<<<< HEAD
  version = "0.9.1";
=======
  version = "0.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_llms_ollama";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-1Yhe1lri4rx0up4//TpbzXxTQe8GcOPZ/iAIgPwZ+aY=";
=======
    hash = "sha256-zfoWf36oB0+/1Qs+gBU9bQX6O05y5TCxjcVPd1GFA9E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    ollama
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.ollama" ];

<<<<<<< HEAD
  meta = {
    description = "LlamaIndex LLMS Integration for ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "LlamaIndex LLMS Integration for ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
