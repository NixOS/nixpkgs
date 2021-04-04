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
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54431535309cfab50897d9c181e8c2226268825aa6e42e930b05b99c5041a18c";
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
