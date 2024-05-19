{ lib
, buildPythonPackage
, fetchFromGitHub
, ibm-cloud-sdk-core
, pytest-rerunfailures
, pytestCheckHook
, python-dateutil
, python-dotenv
, pythonOlder
, requests
, responses
, websocket-client
}:

buildPythonPackage rec {
  pname = "ibm-watson";
  version = "8.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-r7A5i17KIy1pBrj01yeknfrOFjb5yZco8ZOc7tlFM7k=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "ibm_watson"
  ];

  meta = with lib; {
    description = "Client library to use the IBM Watson Services";
    homepage = "https://github.com/watson-developer-cloud/python-sdk";
    changelog = "https://github.com/watson-developer-cloud/python-sdk/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
