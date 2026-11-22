{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-readers-database";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_database";
    inherit (finalAttrs) version;
    hash = "sha256-UK+omoo20E99vWkN9kLTsZ7DSK+0ZI7wIzQHnrASmJI=";
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
})
