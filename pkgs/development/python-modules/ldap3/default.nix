{ stdenv, fetchPypi, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59d1adcd5ead263387039e2a37d7cd772a2006b1cdb3ecfcbaab5192a601c515";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/ldap3";
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
