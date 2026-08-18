{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  hatchling,
}:

buildPythonPackage rec {
  pname = "llama-index-vector-stores-google";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_google";
    inherit version;
    hash = "sha256-lf1Wr8l6azfxrokcGilR+IriU465LmFXDiqfHrCdrO0=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [
    hatchling
  ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.google" ];

  meta = {
    description = "LlamaIndex Vector Store Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-google";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
