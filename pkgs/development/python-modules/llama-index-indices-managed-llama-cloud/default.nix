{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  llama-cloud,
  llama-index-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-indices-managed-llama-cloud";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_indices_managed_llama_cloud";
    inherit version;
    hash = "sha256-AqHQtBP/+1UCLn6E4FeIzLGMvc9Uz+wEZthMVlUJ+uY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    llama-cloud
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.indices.managed.llama_cloud" ];

  meta = with lib; {
    description = "LlamaCloud Index and Retriever";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/indices/llama-index-indices-managed-llama-cloud";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
