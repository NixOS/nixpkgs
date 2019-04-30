{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, click
, mock
, pytest
, futures
, google_auth
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "226d1d0960f86ba5d9efd426a70b291eaba96f47d071657e0254ea969025728a";
  };

  checkInputs = [
    click mock pytest
  ] ++ lib.optionals (!isPy3k) [ futures ];

  propagatedBuildInputs = [
    google_auth requests_oauthlib
  ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib;
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
