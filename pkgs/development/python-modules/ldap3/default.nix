{ stdenv, fetchPypi, buildPythonPackage, gssapi, pyasn1 }:

buildPythonPackage rec {
  version = "2.5.2";
  pname = "ldap3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "063dacy01mphc3n7z2qc2avykjavqm1gllkbvy7xzw5ihlqwhrrz";
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
