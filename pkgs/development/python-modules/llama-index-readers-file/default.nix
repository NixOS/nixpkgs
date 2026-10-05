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

buildPythonPackage (finalAttrs: {
  pname = "llama-index-readers-file";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_file";
    inherit (finalAttrs) version;
    hash = "sha256-Mo4/5dptphcuPXG2C1x2wWdnB7IgyPxH7fqnlfmu/RY=";
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

  meta = {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-file";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
