{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-cloud-services,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-parse";
  version = "0.6.54";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-xwezEVIVXJuuhOMW+reQu8jIX02IJc5e44br632yWPE=";
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
