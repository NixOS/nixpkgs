{ lib
, buildPythonPackage
, fetchPypi
, twisted
, passlib
, pyopenssl
, pyparsing
, service-identity
, zope_interface
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "ldaptor";
  version = "19.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64c7b870c77e34e4f5f9cfdf330b9702e89b4dd0f64275704f86c1468312c755";
  };

  propagatedBuildInputs = [
    twisted passlib pyopenssl pyparsing service-identity zope_interface
  ];

  disabled = isPy3k;

  doCheck = false;

  meta = {
    description = "A Pure-Python Twisted library for LDAP";
    homepage = "https://github.com/twisted/ldaptor";
    license = lib.licenses.mit;
  };
}
