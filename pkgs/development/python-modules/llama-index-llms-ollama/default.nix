{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  ollama,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-llms-ollama";
  version = "0.5.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_ollama";
    inherit version;
    hash = "sha256-RDiMv6riuVcvbqZzTAcBXHcoI/vm0ssmx9/jT65R3cU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    ollama
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.llms.ollama" ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
