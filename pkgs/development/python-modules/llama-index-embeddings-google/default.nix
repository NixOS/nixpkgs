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
  pname = "llama-index-embeddings-google";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_embeddings_google";
    inherit version;
    hash = "sha256-jQYN/5XPCrMjvwXBARdRDLC+3JhqgZjlcVajmcRlVJw=";
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

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.embeddings.google"
  ];

  meta = with lib; {
    description = "LlamaIndex Embeddings Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/embeddings/llama-index-embeddings-google";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
