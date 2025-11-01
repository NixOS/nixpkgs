{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-cloud-services,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-parse";
  version = "0.6.77";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-cxjDJT/ADoPwDmN4Cg06AyQvJcasGZwmw6ctuHVNRLc=";
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
