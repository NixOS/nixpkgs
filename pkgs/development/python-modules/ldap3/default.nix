{ stdenv, fetchPypi, buildPythonPackage, gssapi, pyasn1 }:

buildPythonPackage rec {
  version = "2.4.1";
  pname = "ldap3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a66pc00az0nx9kvhzidbg099pvk52ngycf891bp5jyfm1ahvzp8";
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
