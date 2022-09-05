{ lib
, buildPythonPackage
, fetchFromGitHub
, responses
, pytestCheckHook
, python-dotenv
, pytest-rerunfailures
, tox
, requests
, python-dateutil
, websocket-client
, ibm-cloud-sdk-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ibm-watson";
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-jvDkAwuDFgo7QlZ8N7TNVsY7+aXdIDc50uIIoO+5MLs=";
  };

  propagatedBuildInputs = [
    requests
    python-dateutil
    websocket-client
    ibm-cloud-sdk-core
  ];

  checkInputs = [
    responses
    pytestCheckHook
    python-dotenv
    pytest-rerunfailures
    tox
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace websocket-client==1.1.0 websocket-client>=1.1.0
  '';

  pythonImportsCheck = [
    "ibm_watson"
  ];

  meta = with lib; {
    description = "Client library to use the IBM Watson Services";
    homepage = "https://github.com/watson-developer-cloud/python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
