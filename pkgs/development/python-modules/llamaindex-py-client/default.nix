{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  poetry-core,
  pydantic,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "llamaindex-py-client";
  version = "0.1.19";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llamaindex_py_client";
    inherit version;
    hash = "sha256-c/dHkruMCSuubcYmYnoJrBOgmfqNEPj8yD4XorMyzKc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "llama_index_client" ];

  meta = with lib; {
    description = "Client for LlamaIndex";
    homepage = "https://pypi.org/project/llamaindex-py-client/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
