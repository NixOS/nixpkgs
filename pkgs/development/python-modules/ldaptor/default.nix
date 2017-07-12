{ stdenv, buildPythonPackage, fetchPypi, zope_interface, pyparsing, twisted
, pycrypto, pyopenssl
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "ldaptor";
  version = "16.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pc12f1dzbnx7i0gzqkq8s5m0iivwzmbzqy40cbhkrz92icbx7kb";
  };

  propagatedBuildInputs = [
    zope_interface pyparsing twisted pycrypto pyopenssl
  ];

  meta = with stdenv.lib; {
    description = "LDAP server, client and utilities, using Twisted Python";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
