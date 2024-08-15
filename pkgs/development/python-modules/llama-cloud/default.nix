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
  pname = "llama-cloud";
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_cloud";
    inherit version;
    hash = "sha256-DjFloi+N80oA0T8fVzlDi6TWIPLYqSid+DAHijn+bx8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "llama_cloud" ];

  meta = with lib; {
    description = "LlamaIndex Python Client";
    homepage = "https://pypi.org/project/llama-cloud/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
