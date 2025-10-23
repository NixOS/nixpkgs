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
  pythonOlder,
  striprtf,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-file";
  version = "0.5.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_file";
    inherit version;
    hash = "sha256-XnZvMll2IuZlKUZBAZFFSK1oN3CgpdK9ye6E6zoRAzI=";
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
