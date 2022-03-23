{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, click
, mock
, pytestCheckHook
, google-auth
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BsTOs6sqk7hbiXa76Gy7gq4dHALS3tPP0IR6i2lVJjs=";
  };

  propagatedBuildInputs = [
    google-auth
    requests_oauthlib
  ];

  checkInputs = [
    click
    mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_run_local_server" ];

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 terlar ];
  };
}
