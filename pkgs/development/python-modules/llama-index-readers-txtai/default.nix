{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-txtai";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_txtai";
    inherit version;
    hash = "sha256-0eOJ9r27lG6WwOz27+N5qldROoaU5UAewtY4N4m8Kcs=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.txtai" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for txtai";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-txtai";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
