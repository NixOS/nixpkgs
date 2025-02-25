{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ibm-cloud-sdk-core,
  pytest-rerunfailures,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  pythonOlder,
  requests,
  setuptools,
  responses,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ibm-watson";
  version = "9.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-JZriBvdeDAZ+NOnWCsjI2m5JlLe/oLlbtFkdFeuL8TI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    ibm-cloud-sdk-core
    python-dateutil
    requests
    websocket-client
  ];

  nativeCheckInputs = [
    pytest-rerunfailures
    pytestCheckHook
    python-dotenv
    responses
  ];

  pythonImportsCheck = [ "ibm_watson" ];

  meta = with lib; {
    description = "Client library to use the IBM Watson Services";
    homepage = "https://github.com/watson-developer-cloud/python-sdk";
    changelog = "https://github.com/watson-developer-cloud/python-sdk/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
