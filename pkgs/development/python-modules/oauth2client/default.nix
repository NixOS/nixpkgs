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
    sha256 = "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6";
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
