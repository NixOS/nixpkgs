{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  poetry-core,
  pydantic,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "llama-cloud";
<<<<<<< HEAD
  version = "0.1.45";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_cloud";
    inherit version;
    hash = "sha256-FAJEAIzFcQ4xrpfGBDlzo6mWmlGw84FV+jOoQ0B46Ko=";
=======
  version = "0.1.44";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_cloud";
    inherit version;
    hash = "sha256-J2orT5RGPaA3QxyjBjMxs7a+OYu/sAMRPudrfCqHO1M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "llama_cloud" ];

<<<<<<< HEAD
  meta = {
    description = "LlamaIndex Python Client";
    homepage = "https://pypi.org/project/llama-cloud/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "LlamaIndex Python Client";
    homepage = "https://pypi.org/project/llama-cloud/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
