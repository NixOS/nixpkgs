{
  lib,
  buildPythonPackage,
  fetchPypi,
  twisted,
  passlib,
  pyparsing,
  six,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "ldaptor";
  version = "21.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jEnrGTddSqs+W4NYYGFODLF+VrtaIOGHSAj6W+xno1g=";
  };

  propagatedBuildInputs = [
    passlib
    pyparsing
    six
    twisted
    zope-interface
  ]
  ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [ twisted ];

  # Test creates an excessive amount of temporary files (order of millions).
  # Cleaning up those files already took over 15 hours already on my zfs
  # filesystem and is not finished yet.
  doCheck = false;

  checkPhase = ''
    trial -j$NIX_BUILD_CORES ldaptor
  '';

  meta = {
    description = "Pure-Python Twisted library for LDAP";
    homepage = "https://github.com/twisted/ldaptor";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
