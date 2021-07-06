{ lib, fetchPypi, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18c3ee656a6775b9b0d60f7c6c5b094d878d1d90fc03d56731039f0a4b546a91";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/ldap3";
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
