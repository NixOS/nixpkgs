{ lib, buildPythonPackage, fetchPypi
, httplib2, six, oauth2client, uritemplate }:

buildPythonPackage rec {
  pname = "google-api-python-client";
  version = "1.6.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec72991f95201996a4edcea44a079cae0292798086beaadb054d91921632fe1b";
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
