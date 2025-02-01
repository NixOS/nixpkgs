{
  lib,
  asyncpg,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  pgvector,
  poetry-core,
  psycopg2,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-postgres";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_postgres";
    inherit version;
    hash = "sha256-Ny1hKQUwrzvb/GI2WRa80i0EsE92oqSEdj6hFBle6H8=";
  };

  pythonRemoveDeps = [ "psycopg2-binary" ];

  pythonRelaxDeps = [
    "pgvector"
  ];

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

  meta = {
    description = "LlamaIndex Vector Store Integration for Postgres";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-postgres";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
