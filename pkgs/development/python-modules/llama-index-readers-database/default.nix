{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-database";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_database";
    inherit version;
    hash = "sha256-5Ffw3Ro7+vmskRI8xr1gRTxgEyMCn7GWHn6I4mEcnoY=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.database" ];

  meta = {
    description = "LlamaIndex Readers Integration for Databases";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-database";
    changelog = "https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/readers/llama-index-readers-database/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
