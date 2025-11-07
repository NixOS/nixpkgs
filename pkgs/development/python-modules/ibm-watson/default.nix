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
  version = "11.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-FSzuPRiJ6OXkdy4XyvGs2kTKPF2Kl55e53keztmEdfY=";
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

  # FileNotFoundError: [Errno 2] No such file or directory: './auth.json'
  disabledTestPaths = [
    "test/integration/test_assistant_v2.py"
    "test/integration/test_natural_language_understanding_v1.py"
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
