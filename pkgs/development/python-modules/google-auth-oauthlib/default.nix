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
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fl3w23c93hlgqf0l57cdy17wmvyhrv3bh133ksd2h490ir012va";
  };

  checkInputs = [
    click mock pytest
  ] ++ lib.optionals (!isPy3k) [ futures ];

  propagatedBuildInputs = [
    google_auth requests_oauthlib
  ];

  checkPhase = ''
    rm -fr tests/__pycache__/
    py.test
  '';

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib;
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
