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
  version = "0.5.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-ILAOCbFNG1ehsEDkvWFDbVH0Nza3tRADBypNBbA170Q=";
  };

  build-system = [ poetry-core ];

  dependencies = [ llama-index-core ];

  pythonImportsCheck = [ "llama_parse" ];

  meta = with lib; {
    description = "Parse files into RAG-Optimized formats";
    homepage = "https://pypi.org/project/llama-parse/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
