{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-readers-database";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_readers_database";
    inherit version;
    hash = "sha256-9hbaUioGe8KVWX1O+Bwx0aOvJtVGb4lX/SZwYNJ/Xp0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.readers.database"
  ];

  meta = with lib; {
    description = "LlamaIndex Readers Integration for Databases";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/readers/llama-index-readers-database";
    changelog = "https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/readers/llama-index-readers-database/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
