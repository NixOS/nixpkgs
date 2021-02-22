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
, pythonAtLeast
, python
}:

buildPythonPackage rec {
  pname = "ldaptor";
  version = "20.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "778f45d68a0b5d63a892c804c05e57b464413a41d8ae52f92ae569321473ab67";
  };

  propagatedBuildInputs = [
    twisted passlib pyopenssl pyparsing service-identity zope_interface
  ];

  # https://github.com/twisted/ldaptor/pull/210
  disabled = !isPy3k || pythonAtLeast "3.9";

  checkPhase = ''
    ${python.interpreter} -m twisted.trial ldaptor
  '';

  meta = {
    description = "A Pure-Python Twisted library for LDAP";
    homepage = "https://github.com/twisted/ldaptor";
    license = lib.licenses.mit;
  };
}
