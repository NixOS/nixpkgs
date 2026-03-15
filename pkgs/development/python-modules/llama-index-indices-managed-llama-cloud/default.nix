{
  lib,
  buildPythonPackage,
  fetchPypi,
  deprecated,
  hatchling,
  llama-cloud,
  llama-index-core,
}:

buildPythonPackage rec {
  pname = "llama-index-indices-managed-llama-cloud";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_indices_managed_llama_cloud";
    inherit version;
    hash = "sha256-R4nVEVJIGzSabVFg5CkIl1fQ+jwNd5DZayUK3ZCaiJ0=";
  };

  pythonRelaxDeps = [
    "deprecated"
    "llama-cloud"
  ];

  build-system = [ hatchling ];

  dependencies = [
    deprecated
    llama-cloud
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.indices.managed.llama_cloud" ];

  meta = {
    description = "LlamaCloud Index and Retriever";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/indices/llama-index-indices-managed-llama-cloud";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
