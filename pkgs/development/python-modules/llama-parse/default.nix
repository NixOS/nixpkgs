{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-cloud-services,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-parse";
  version = "0.6.90";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-7OqBGrj6lKe4Y90NNYQRPGMFRRM2i64ix6LYtnzPOu0=";
  };

  build-system = [ hatchling ];

  dependencies = [ llama-cloud-services ];

  pythonImportsCheck = [ "llama_parse" ];

  meta = {
    description = "Parse files into RAG-Optimized formats";
    homepage = "https://pypi.org/project/llama-parse/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
