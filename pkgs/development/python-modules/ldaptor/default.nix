{ lib
, buildPythonPackage
, fetchPypi
, twisted
, passlib
, pyparsing
, service-identity
, six
, zope_interface
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "ldaptor";
  version = "21.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jEnrGTddSqs+W4NYYGFODLF+VrtaIOGHSAj6W+xno1g=";
  };

  propagatedBuildInputs = [
    passlib
    pyparsing
    six
    twisted
    zope_interface
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    twisted
  ];

  # Test creates an excessive amount of temporary files (order of millions).
  # Cleaning up those files already took over 15 hours already on my zfs
  # filesystem and is not finished yet.
  doCheck = false;

  checkPhase = ''
    trial -j$NIX_BUILD_CORES ldaptor
  '';

  meta = with lib; {
    description = "A Pure-Python Twisted library for LDAP";
    homepage = "https://github.com/twisted/ldaptor";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
