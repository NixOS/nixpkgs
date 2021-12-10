{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, click
, mock
, pytestCheckHook
, google-auth
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "0.4.6";

  src = fetchFromGitHub {
     owner = "GoogleCloudPlatform";
     repo = "google-auth-library-python-oauthlib";
     rev = "v0.4.6";
     sha256 = "1k9vg8wwwqygqv0sghgnglj9hxfkzmy5v6668smq39zs92awks3q";
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
