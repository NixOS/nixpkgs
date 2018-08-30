{ lib, buildPythonPackage, fetchPypi
, six, httplib2, pyasn1-modules, rsa }:

buildPythonPackage rec {
  pname = "oauth2client";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd3062c06f8b10c6ef7a890b22c2740e5f87d61b6e1f4b1c90d069cdfc9dadb5";
  };

  propagatedBuildInputs = [ six httplib2 pyasn1-modules rsa ];
  doCheck = false;

  meta = with lib; {
    description = "A client library for OAuth 2.0";
    homepage = https://github.com/google/oauth2client/;
    license = licenses.bsd2;
  };
}
