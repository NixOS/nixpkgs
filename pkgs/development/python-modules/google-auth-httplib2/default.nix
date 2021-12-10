{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, google-auth
, httplib2
, mock
, pytestCheckHook
, pytest-localserver
}:

buildPythonPackage rec {
  pname = "google-auth-httplib2";
  version = "0.1.0";

  src = fetchFromGitHub {
     owner = "GoogleCloudPlatform";
     repo = "google-auth-library-python-httplib2";
     rev = "v0.1.0";
     sha256 = "14l3ck0s32f7qsg7va5zriz8p3n684j0ybhvp1ih4zskxd6z2iv0";
  };

  propagatedBuildInputs = [
    google-auth
    httplib2
  ];

  checkInputs = [
    flask
    mock
    pytestCheckHook
    pytest-localserver
  ];

  meta = with lib; {
    description = "Google Authentication Library: httplib2 transport";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
