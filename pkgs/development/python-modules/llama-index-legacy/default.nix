{
  lib,
  buildPythonPackage,
  fetchPypi,
  llama-index-core,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llama-index-legacy";
  version = "0.9.48.post4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_legacy";
    inherit version;
    hash = "sha256-+Kl2Tn4TSlK/715T0tYlYb/AH8CYdMUcwAHfb1MCrjA=";
  };

  pythonRelaxDeps = [ "tenacity" ];

  build-system = [ poetry-core ];

  dependencies = [ llama-index-core ];

  # Tests are only available in the mono repo
  doCheck = false;

  meta = with lib; {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/v0.9.48";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
