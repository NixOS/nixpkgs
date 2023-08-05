{ lib
, buildPythonPackage
, fetchFromGitHub
, responses
, pytestCheckHook
, python-dotenv
, pytest-rerunfailures
, requests
, python-dateutil
, websocket-client
, ibm-cloud-sdk-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ibm-watson";
  version = "7.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "watson-developer-cloud";
    repo = "python-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-AerEd4TkK/A0KhSy+QWxRDD4pjobsx4oDxMr+wUCGt0=";
  };

  propagatedBuildInputs = [
    requests
    python-dateutil
    websocket-client
    ibm-cloud-sdk-core
  ];

  nativeCheckInputs = [
    responses
    pytestCheckHook
    python-dotenv
    pytest-rerunfailures
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
