{ lib
, buildPythonPackage
, fetchPypi
, google-generativeai
, llama-index-core
, poetry-core
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-google";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_google";
    inherit version;
    hash = "sha256-5HjbymV7wdcu/C+ndWCxj3j10QIgVqUaSaZ4cRMJ46U=";
  };

  pythonRelaxDeps = [
    "google-generativeai"
  ];

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.vector_stores.google"
  ];

  meta = with lib; {
    description = "LlamaIndex Vector Store Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-google";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
