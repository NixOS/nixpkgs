{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ibm-cloud-sdk-core,
  pytest-rerunfailures,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  requests,
  setuptools,
  responses,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ibm-watson";
  version = "11.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-z+sGfYbPZcHQh6JGdVC2DDFHd0VIgC2GmvGvN+hrXU0=";
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

  meta = {
    description = "Client library to use the IBM Watson Services";
    homepage = "https://github.com/watson-developer-cloud/python-sdk";
    changelog = "https://github.com/watson-developer-cloud/python-sdk/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
