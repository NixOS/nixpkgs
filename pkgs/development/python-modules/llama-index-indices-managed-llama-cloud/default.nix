{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-cloud,
  llama-index-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-indices-managed-llama-cloud";
  version = "0.7.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_indices_managed_llama_cloud";
    inherit version;
    hash = "sha256-4ikB7W8jD2V5JYDmMnJBVqwvtBtjK1RdDC2Qbt9M4U8=";
  };

  pythonRelaxDeps = [ "llama-cloud" ];

  build-system = [ hatchling ];

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
