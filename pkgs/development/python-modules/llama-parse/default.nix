{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-parse";
  version = "0.5.19";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-22nacOGZomZHBeuYOnD6krfO4Z3Wz/F1r3aSoLik3VM=";
  };

  build-system = [ poetry-core ];

  dependencies = [ llama-index-core ];

  pythonImportsCheck = [ "llama_parse" ];

  meta = {
    description = "Parse files into RAG-Optimized formats";
    homepage = "https://pypi.org/project/llama-parse/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
