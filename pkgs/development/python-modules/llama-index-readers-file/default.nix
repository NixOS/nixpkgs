{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pymupdf,
  pypdf,
  pythonOlder,
  pythonRelaxDepsHook,
  striprtf,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-file";
  version = "0.1.22";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_file";
    inherit version;
    hash = "sha256-N95UrQz73GB8GVUyuaKSQXpHFPV3c1cLhwJ7jcOB8OI=";
  };

  pythonRelaxDeps = [
    "pymupdf"
    "pypdf"
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    beautifulsoup4
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
