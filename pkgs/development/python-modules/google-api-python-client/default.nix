{ lib, buildPythonPackage, fetchPypi
, httplib2, six, oauth2client, uritemplate }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05583a386e323f428552419253765314a4b29828c3cee15be735f9ebfa5aebf2";
  };

  # No tests included in archive
  doCheck = false;

  propagatedBuildInputs = [ httplib2 six oauth2client uritemplate ];

  meta = with lib; {
    description = "The core Python library for accessing Google APIs";
    homepage = https://github.com/google/google-api-python-client;
    license = licenses.asl20;
  };
}
