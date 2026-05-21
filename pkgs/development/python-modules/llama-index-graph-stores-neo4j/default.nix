{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  llama-index-core,
  neo4j,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-graph-stores-neo4j";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_graph_stores_neo4j";
    inherit (finalAttrs) version;
    hash = "sha256-q+S7NIxlIAXR75cN7IUS2uZYLFDYO7r1nOLVMDHmYSA=";
  };

  pythonRelaxDeps = [ "neo4j" ];

  build-system = [ hatchling ];

  dependencies = [
    neo4j
    llama-index-core
  ];

  # Tests are not shipped with PyPI package
  doCheck = false;

  pythonImportsCheck = [ "llama_index.graph_stores.neo4j" ];

  meta = {
    description = "LlamaIndex Graph Store Integration for Neo4j";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-neo4j";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
