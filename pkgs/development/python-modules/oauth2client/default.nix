{ lib, buildPythonPackage, fetchPypi
, six, httplib2, pyasn1-modules, rsa }:

buildPythonPackage rec {
  pname = "oauth2client";
  version = "1.4.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0phfk6s8bgpap5xihdk1xv2lakdk1pb3rg6hp2wsg94hxcxnrakl";
  };

  propagatedBuildInputs = [ six httplib2 pyasn1-modules rsa ];
  doCheck = false;

  meta = with lib; {
    description = "A client library for OAuth 2.0";
    homepage = https://github.com/google/oauth2client/;
    license = licenses.bsd2;
  };
}
