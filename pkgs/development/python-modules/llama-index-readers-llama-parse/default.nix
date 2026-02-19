{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  llama-parse,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-llama-parse";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_llama_parse";
    inherit version;
    hash = "sha256-K3i3P6qTPjDmxp3zUeTp823+KuFC4qs5ad3SrEiTDjc=";
  };

  pythonRelaxDeps = [ "llama-parse" ];

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    llama-parse
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.llama_parse" ];

  meta = {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-llama-parse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
