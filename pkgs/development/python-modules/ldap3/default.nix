{ stdenv, fetchPypi, buildPythonPackage, gssapi, pyasn1 }:

buildPythonPackage rec {
  version = "2.3";
  pname = "ldap3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b36lwil4iflk2ay8gi663abpnfm8id7qg4n3jkmmqbnc1sv6mn0";
  };

  buildInputs = [ gssapi ];

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/ldap3;
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
