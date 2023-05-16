{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, callee
, fetchPypi
, mock
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "auth0-python";
<<<<<<< HEAD
  version = "4.4.0";
=======
  version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Yf8/NmQygdikQXv9sUukQEKKd+FcpSPnGbbi8kzVyLo=";
=======
    hash = "sha256-DyFRCQGjyv75YVBPN+1xWjKQtPUv29xblYu2TehkkVo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
    pyjwt
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    aiohttp
    aioresponses
    callee
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Tries to ping websites (e.g. google.com)
    "can_timeout"
    "test_options_are_created_by_default"
    "test_options_are_used_and_override"
  ];

  pythonImportsCheck = [
    "auth0"
  ];

  meta = with lib; {
    description = "Auth0 Python SDK";
    homepage = "https://github.com/auth0/auth0-python";
    changelog = "https://github.com/auth0/auth0-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
