{ stdenv, fetchPypi, buildPythonPackage, pyasn1 }:

buildPythonPackage rec {
  pname = "ldap3";
  version = "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h1q8g1c2nkhx8p5n91bzkvjx5js5didi9xqbnmfrxqbnyc45w0p";
  };

  propagatedBuildInputs = [ pyasn1 ];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/ldap3";
    description = "A strictly RFC 4510 conforming LDAP V3 pure Python client library";
    license = licenses.lgpl3;
  };
}
