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

  disabledTests = lib.optionals stdenv.isDarwin [
    # This test fails if the hostname is not associated with an IP (e.g., in `/etc/hosts`).
    "test_run_local_server_bind_addr"
  ];

  pythonImportsCheck = [
    "google_auth_oauthlib"
  ];

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
