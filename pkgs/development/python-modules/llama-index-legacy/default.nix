{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-legacy";
  version = "0.9.48";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_legacy";
    inherit version;
    hash = "sha256-gt3EaR7b9JUz1lWCwkm6IsA/6W+9PpL3dY3M7yjkODQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  meta = with lib; {
    description = "LlamaIndex Readers Integration for files";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-legacy";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
