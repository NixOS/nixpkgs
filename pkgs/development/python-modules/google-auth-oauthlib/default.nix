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
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gQVqMQ+xxKPlp+GkQ+Hrllk8a7xVsmwCYeTTKV0+ZZM=";
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
    maintainers = with maintainers; [ SuperSandro2000 terlar ];
  };
}
