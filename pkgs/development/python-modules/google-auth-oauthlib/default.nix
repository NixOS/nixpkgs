{ lib
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
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nai9k86g7g7w1pxk105dllncgax8nc5hpmk758b3jnqkb1mpdk5";
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

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 terlar ];
  };
}
