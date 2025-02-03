{
  lib,
  asyncpg,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  pgvector,
  poetry-core,
  psycopg2,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-postgres";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_postgres";
    inherit version;
    hash = "sha256-JLJygIsklBM9B3mOeQP8fu6YuHo104rvJKNj83eAQc4=";
  };

  pythonRemoveDeps = [ "psycopg2-binary" ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    asyncpg
    llama-index-core
    pgvector
    psycopg2
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.postgres" ];

  meta = with lib; {
    description = "LlamaIndex Vector Store Integration for Postgres";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-postgres";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
