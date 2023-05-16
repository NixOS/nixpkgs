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
  version = "26.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kubernetes-client";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-2QkQGZ4Dho2PykH90ijosWWBzhQoCHoWhRL3ruOiDBg=";
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
<<<<<<< HEAD
    maintainers = with maintainers; [ lsix ];
=======
    maintainers = with maintainers; [ lsix SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
