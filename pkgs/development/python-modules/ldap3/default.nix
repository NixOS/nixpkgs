{ stdenv, fetchPypi, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37d633e20fa360c302b1263c96fe932d40622d0119f1bddcb829b03462eeeeb7";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/ldap3";
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
