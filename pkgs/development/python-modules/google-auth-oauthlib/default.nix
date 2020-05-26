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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88d2cd115e3391eb85e1243ac6902e76e77c5fe438b7276b297fbe68015458dd";
  };

  checkInputs = [
    click mock pytest
  ] ++ lib.optionals (!isPy3k) [ futures ];

  propagatedBuildInputs = [
    google_auth requests_oauthlib
  ];

  doCheck = isPy3k;
  checkPhase = ''
    rm -fr tests/__pycache__/ google
    py.test
  '';

  meta = with lib; {
    description = "Google Authentication Library: oauthlib integration";
    homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib";
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
