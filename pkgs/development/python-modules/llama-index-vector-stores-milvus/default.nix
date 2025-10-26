{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  pymilvus,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-milvus";
  version = "0.9.3";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_milvus";
    inherit version;
    hash = "sha256-JiGsSKKlwV3efEkT5p3lXcEY7hCbVWRdCAX9X539Ke0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    pymilvus
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.milvus" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Llama-index vector_stores milvus integration";
    homepage = "https://pypi.org/project/llama-index-vector-stores-milvus/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
