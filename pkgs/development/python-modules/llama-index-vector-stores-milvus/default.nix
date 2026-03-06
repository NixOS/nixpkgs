{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  pymilvus,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-vector-stores-milvus";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_milvus";
    inherit (finalAttrs) version;
    hash = "sha256-u3IqnwF1fe4gkdbsO9n9+wNp/nMdUnTguVeXqaUymUM=";
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
})
