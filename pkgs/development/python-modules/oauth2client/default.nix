{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  httplib2,
  pyasn1-modules,
  rsa,
}:

buildPythonPackage rec {
  pname = "oauth2client";
  version = "4.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1IZ0HkUSh/aVaKTSbXDZrNc6K7+idXRsU1tCCYkczMY=";
  };

  propagatedBuildInputs = [
    six
    httplib2
    pyasn1-modules
    rsa
  ];
  doCheck = false;

  meta = with lib; {
    description = "Client library for OAuth 2.0";
    homepage = "https://github.com/google/oauth2client/";
    license = licenses.bsd2;
  };
}
