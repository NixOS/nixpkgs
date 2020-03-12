{ lib, buildPythonPackage, fetchPypi
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "137vwb9544vjxkwnbr98x0f4p6ri5i678wxxxgbsx4kdyrs83a58";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ httplib2 google_auth google-auth-httplib2 six uritemplate oauth2client ];

  meta = with lib; {
    description = "The core Python library for accessing Google APIs";
    homepage = https://github.com/google/google-api-python-client;
    license = licenses.asl20;
    maintainers = with maintainers; [ primeos ];
  };
}
