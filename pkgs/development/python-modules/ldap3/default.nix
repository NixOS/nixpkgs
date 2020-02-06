{ stdenv, fetchPypi, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ag5xqlki6pjk3f50b8ar8vynx2fmkna7rfampv3kdgwg8z6gjr7";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/ldap3;
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
