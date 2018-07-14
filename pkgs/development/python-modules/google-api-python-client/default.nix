{ lib, buildPythonPackage, fetchPypi
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e32d30563b90c4f88ff042d4d891b5e8ed1f6cdca0adab95e9c2ce2603087436";
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
