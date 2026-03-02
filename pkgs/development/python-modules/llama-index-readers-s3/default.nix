{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  llama-index-readers-file,
  hatchling,
  s3fs,
}:

buildPythonPackage rec {
  pname = "llama-index-readers-s3";
  version = "0.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_readers_s3";
    inherit version;
    hash = "sha256-Ye+B4lcwdeaAisaIZH98X2n7FA7n9/gkVVNRN1uihys=";
  };

  build-system = [ hatchling ];

  dependencies = [
    llama-index-core
    llama-index-readers-file
    s3fs
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [ "llama_index.readers.s3" ];

  meta = {
    description = "LlamaIndex Readers Integration for S3";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-s3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
