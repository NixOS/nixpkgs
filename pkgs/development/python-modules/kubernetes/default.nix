{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# propgatedBuildInputs
, adal
, certifi
, google-auth
, python-dateutil
, pyyaml
, requests
, requests_oauthlib
, urllib3
, websocket-client

# tests
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "18.20.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    rev = "v${version}";
    sha256 = "1sawp62j7h0yksmg9jlv4ik9b9i1a1w9syywc9mv8x89wibf5ql1";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    adal
    certifi
    google-auth
    python-dateutil
    pyyaml
    requests
    requests_oauthlib
    urllib3
    websocket-client
  ];

  pythonImportsCheck = [
    "kubernetes"
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Kubernetes python client";
    homepage = "https://github.com/kubernetes-client/python";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
