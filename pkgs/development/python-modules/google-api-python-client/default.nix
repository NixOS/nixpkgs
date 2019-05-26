{ lib, buildPythonPackage, fetchPypi, isPy3k
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v551xaavqff085gplinnnrz2sk6sikmm7j47gi0wf34hpba1384";
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
