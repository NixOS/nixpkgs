{ stdenv, fetchPypi, buildPythonPackage, gssapi, pyasn1 }:

buildPythonPackage rec {
  version = "2.5.1";
  pname = "ldap3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc09951809678cfb693a13a6011dd2d48ada60a52bd80cb4bd7dcc55ee7c02fd";
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
