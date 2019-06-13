{ stdenv, fetchPypi, fetchFromGitHub, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f0v82584b7gkzrnnnl4fc88w4i73x7cxqbzy0r0bknm33yfwcq5";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/ldap3;
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
