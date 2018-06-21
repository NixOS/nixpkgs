{ stdenv, fetchPypi, buildPythonPackage, gssapi, pyasn1 }:

buildPythonPackage rec {
  version = "2.5";
  pname = "ldap3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "117392bma5hlc9x2gq34av7zrz974r041h5lcy45lw8zk2y8n1sm";
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
