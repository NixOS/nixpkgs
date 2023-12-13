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
, requests-oauthlib
, setuptools
, six
, urllib3
, websocket-client

# tests
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "kubernetes";
  version = "27.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-KqQ7wUu5Se4WYOdtk9vMU3M5oyz0WgIltSEliCD7s10=";
  };

  propagatedBuildInputs = [
    adal
    certifi
    google-auth
    python-dateutil
    pyyaml
    requests
    requests-oauthlib
    setuptools
    six
    urllib3
    websocket-client
  ];

  pythonImportsCheck = [
    "kubernetes"
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    # AssertionError: <class 'urllib3.poolmanager.ProxyManager'> != <class 'urllib3.poolmanager.Poolmanager'>
    "test_rest_proxycare"
  ];

  meta = with lib; {
    description = "Kubernetes Python client";
    homepage = "https://github.com/kubernetes-client/python";
    license = licenses.asl20;
    maintainers = with maintainers; [ lsix ];
  };
}
