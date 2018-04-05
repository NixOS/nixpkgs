{ lib, buildPythonPackage, fetchPypi
, httplib2, six, oauth2client, uritemplate }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ggxk094vqr4ia6yq7qcpa74b4x5cjd5mj74rq0xx9wp2jkrxmig";
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
