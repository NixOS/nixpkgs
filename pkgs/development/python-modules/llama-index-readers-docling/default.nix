{
  lib,
  buildPythonPackage,
  docling-core,
  docling,
  fetchPypi,
  hatchling,
  llama-index-core,
  numpy,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-docling";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_docling";
    inherit version;
    hash = "sha256-b9UxJWlh/KnfTIOcKe9jiWCD1VknqeJH2hQjrDNmsOg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    docling
    docling-core
    llama-index-core
    numpy
  ];

  pythonImportsCheck = [ "llama_index.readers.docling" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Llama-index readers docling integration";
    homepage = "https://pypi.org/project/llama-index-readers-docling/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
