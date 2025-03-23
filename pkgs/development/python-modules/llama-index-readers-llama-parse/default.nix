{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  llama-parse,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-llama-parse";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_llama_parse";
    inherit version;
    hash = "sha256-6Z7Fb0+FRtf9oafBriYWL7mst+vKw0O1q9tCNLRkTg8=";
  };

  pythonRelaxDeps = [ "llama-parse" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-parse
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.llama_parse" ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-llama-parse";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
