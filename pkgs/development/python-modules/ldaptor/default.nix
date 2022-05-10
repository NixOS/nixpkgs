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
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jEnrGTddSqs+W4NYYGFODLF+VrtaIOGHSAj6W+xno1g=";
  };

  propagatedBuildInputs = [
    passlib
    pyparsing
    six
    twisted
    zope_interface
  ] ++ twisted.extras-require.tls;

  checkInputs = [
    twisted
  ];

  checkPhase = ''
    trial -j$NIX_BUILD_CORES ldaptor
  '';

  meta = with lib; {
    description = "A Pure-Python Twisted library for LDAP";
    homepage = "https://github.com/twisted/ldaptor";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    # tests hang or fail with "no space left on device"
    broken = true;
  };
}
