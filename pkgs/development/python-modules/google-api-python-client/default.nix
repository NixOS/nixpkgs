{ lib, buildPythonPackage, fetchPypi
, httplib2, google_auth, google-auth-httplib2, six, uritemplate, oauth2client }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d5cb02c6f3112c68eed51b74891a49c0e35263380672d662f8bfe85b8114d7c";
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
