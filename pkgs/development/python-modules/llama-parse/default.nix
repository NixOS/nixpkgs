{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-cloud-services,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-parse";
  version = "0.6.79";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-QT2tN24GUhkKPAzjx9IIBVnufW28yBKVw5cMZvE8B7g=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-cloud-services ];

  pythonImportsCheck = [ "llama_parse" ];

  meta = with lib; {
    description = "Parse files into RAG-Optimized formats";
    homepage = "https://pypi.org/project/llama-parse/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
