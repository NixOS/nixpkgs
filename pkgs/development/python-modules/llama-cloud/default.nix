{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  poetry-core,
  pydantic,
}:

buildPythonPackage rec {
  pname = "llama-cloud";
  version = "0.1.45";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_cloud";
    inherit version;
    hash = "sha256-FAJEAIzFcQ4xrpfGBDlzo6mWmlGw84FV+jOoQ0B46Ko=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "llama_cloud" ];

  meta = {
    description = "LlamaIndex Python Client";
    homepage = "https://pypi.org/project/llama-cloud/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
