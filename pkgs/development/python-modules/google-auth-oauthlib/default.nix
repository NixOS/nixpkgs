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
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a90a072f6993f2c327067bf65270046384cda5a8ecb20b94ea9a687f1f233a7a";
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
