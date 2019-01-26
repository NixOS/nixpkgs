{ lib, buildPythonPackage, fetchPypi, isPy3k
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.7";
  #disabled = !isPy3k; # TODO: Python 2.7 was deprecated but weboob still depends on it.

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nlsp8cll6v9w4649j98xw545bfnqa2xs7m9faa9mxc0kp8ff1li";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ httplib2 google_auth google-auth-httplib2 six uritemplate oauth2client ];

  meta = with lib; {
    description = "The core Python library for accessing Google APIs";
    homepage = https://github.com/google/google-api-python-client;
    license = licenses.asl20;
  };
}
