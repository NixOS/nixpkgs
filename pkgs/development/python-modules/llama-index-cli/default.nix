{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  llama-index-embeddings-openai,
  llama-index-llms-openai,
  llama-index-vector-stores-chroma,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-cli";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_cli";
    inherit version;
    hash = "sha256-1qsgE1mWKoo0Norto6Sbu+Z+ngCcWb2SXE+yvkrOOQY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    llama-index-core
    llama-index-embeddings-openai
    llama-index-llms-openai
    llama-index-vector-stores-chroma
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.cli" ];

  meta = with lib; {
    description = "LlamaIndex CLI";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
