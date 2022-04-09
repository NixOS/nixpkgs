{ lib
, stdenv
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
  version = "20.13.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    rev = "v${version}";
    sha256 = "sha256-zZb5jEQEluY1dfa7UegW+P7MV86ESqOey7kkC74ETlM=";
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

  disabledTests = lib.optionals stdenv.isDarwin [
    # AssertionError: <class 'urllib3.poolmanager.ProxyManager'> != <class 'urllib3.poolmanager.Poolmanager'>
    "test_rest_proxycare"
  ];

  meta = with lib; {
    description = "Kubernetes python client";
    homepage = "https://github.com/kubernetes-client/python";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
