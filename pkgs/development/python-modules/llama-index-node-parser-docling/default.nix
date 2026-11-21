{
  lib,
  buildPythonPackage,
  docling-core,
  fetchPypi,
  hatchling,
  llama-index-core,
}:

buildPythonPackage rec {
  pname = "llama-index-node-parser-docling";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_node_parser_docling";
    inherit version;
    hash = "sha256-OOydqIQnD3prz+MLP0ON97ozXc45wtkKWYqQmbpLgMI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    docling-core
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.node_parser.docling" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Llama-index node_parser docling integration";
    homepage = "https://pypi.org/project/llama-index-node-parser-docling/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
