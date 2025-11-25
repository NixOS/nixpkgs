{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  defusedxml,
  fetchPypi,
  hatchling,
  llama-index-core,
  pymupdf,
  pypdf,
  striprtf,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-file";
  version = "0.5.5";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_file";
    inherit version;
    hash = "sha256-AkuEHP32035OJM6myJ7frF8Or/y8/EkE5LCxaYR8EOU=";
  };

  pythonRelaxDeps = [
    "pymupdf"
    "pypdf"
    "striprtf"
    "pandas"
  ];

  build-system = [ hatchling ];

  dependencies = [
    beautifulsoup4
    defusedxml
    llama-index-core
    pymupdf
    pypdf
    striprtf
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.file" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-file";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
