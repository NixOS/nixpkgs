{ lib
, buildPythonPackage
, fetchPypi
, twisted
, pycrypto
, pyopenssl
, pyparsing
, zope_interface
, isPy3k
}:

buildPythonPackage rec {
  pname = "ldaptor";
  version = "16.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b9ebe5814e9e7091703c4e3bfeae73b46508b4678e2ff403cddaedf8213815d";
  };

  propagatedBuildInputs = [
    twisted pycrypto pyopenssl pyparsing zope_interface
  ];

  disabled = isPy3k;

  # TypeError: None is neither bytes nor unicode
  doCheck = false;

  meta = {
    description = "A Pure-Python Twisted library for LDAP";
    homepage = https://github.com/twisted/ldaptor;
    license = lib.licenses.mit;
  };
}