{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, nebula3-python
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-graph-stores-nebula";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_graph_stores_nebula";
    inherit version;
    hash = "sha256-Xb/0ogj2NlGV4MGC9Be54d/JfalT40jtAe6LOPO1u/8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
    nebula3-python
  ];

  pythonImportsCheck = [
    "llama_index.graph_stores.nebula"
  ];

  meta = with lib; {
    description = "LlamaIndex Graph Store Integration for Nebula";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/graph_stores/llama-index-graph-stores-nebula";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
