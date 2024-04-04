{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, qdrant-client
, poetry-core
, grpcio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-qdrant";
  version = "0.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_qdrant";
    inherit version;
    hash = "sha256-Q4+ehywPz+jrA36AtU9yiicRr2nU6BCO6Y42j0SKPdI=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    grpcio
    llama-index-core
    qdrant-client
  ];

  pythonImportsCheck = [
    "llama_index.vector_stores.qdrant"
  ];

  meta = with lib; {
    description = "LlamaIndex Vector Store Integration for Qdrant";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-qdrant";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
