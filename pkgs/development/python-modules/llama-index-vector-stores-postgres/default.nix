{
  lib,
  asyncpg,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  pgvector,
  hatchling,
  psycopg2,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-vector-stores-postgres";
  version = "0.7.3";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_postgres";
    inherit (finalAttrs) version;
    hash = "sha256-e1xi5GLWgde42GaLk+WwAjv9Oqr8924rS/z4hdw7ScY=";
  };

  pythonRemoveDeps = [ "psycopg2-binary" ];

  pythonRelaxDeps = [ "pgvector" ];

  build-system = [ hatchling ];

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
})
