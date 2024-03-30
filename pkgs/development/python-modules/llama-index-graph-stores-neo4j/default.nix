{ lib
, buildPythonPackage
, fetchPypi
, neo4j
, llama-index-core
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-graph-stores-neo4j";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_graph_stores_neo4j";
    inherit version;
    hash = "sha256-zr3EAFuLzbQKnGPVE6BsLEtNpnfYhDq9brxWPFtQiG8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    neo4j
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.graph_stores.neo4j"
  ];

  meta = with lib; {
    description = "LlamaIndex Graph Store Integration for Neo4j";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-neo4j";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
