{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-readers-json";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_json";
    inherit (finalAttrs) version;
    hash = "sha256-RMyp4abnR3nRGd+35/zpTh3h8EjnzGKs0zOrwHjBeTE=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.json" ];

  meta = {
    description = "LlamaIndex Readers Integration for Json";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-json";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
