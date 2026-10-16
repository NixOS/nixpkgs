{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-txtai";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_txtai";
    inherit version;
    hash = "sha256-X8cf/3KrDNQeVj4zPgRi2CmTbrPxZerLzIJZc9Ln4To=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.txtai" ];

  meta = {
    description = "LlamaIndex Readers Integration for txtai";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-txtai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
