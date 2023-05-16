{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, click
, mock
, pytestCheckHook
, google-auth
, requests-oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-43UGSWSCC0ciGn4bfuH9dwUbYyPD+ePhl4X3irZ+z8U=";
  };

  propagatedBuildInputs = [
    google-auth
    requests-oauthlib
  ];

  nativeCheckInputs = [
    click
    mock
    pytestCheckHook
  ];

  # some tests require loopback networking
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "google_auth_oauthlib"
  ];

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ terlar ];
=======
    maintainers = with maintainers; [ SuperSandro2000 terlar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
