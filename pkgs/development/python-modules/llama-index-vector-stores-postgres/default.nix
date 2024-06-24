{
  lib,
  asyncpg,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  pgvector,
  poetry-core,
  psycopg2,
  pythonRelaxDepsHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-postgres";
  version = "0.1.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_vector_stores_postgres";
    inherit version;
    hash = "sha256-ziP/lUnFJpvcy6Y4h1uSH6qkpYHO+3U+mfg2XIJIeg4=";
  };

  pythonRemoveDeps = [ "psycopg2-binary" ];

  build-system = [
    poetry-core
    pythonRelaxDepsHook
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
