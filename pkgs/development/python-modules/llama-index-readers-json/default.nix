{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-json";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_json";
    inherit version;
    hash = "sha256-ggwpTUnfP1aZhAyZ1wTsoNpW52dt0y5/59JT6RSUMNQ=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.json" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for Json";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-json";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
