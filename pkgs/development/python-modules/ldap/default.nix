{ buildPythonPackage, fetchPypi
, pyasn1, pyasn1-modules, pytest
, openldap, cyrus_sasl, stdenv }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "198as30xy6p760niqps2zdvq2xcmr765h06pmda8fa9y077wl4a7";
  };

  propagatedBuildInputs = [ pyasn1 pyasn1-modules ];

  buildInputs = [ openldap cyrus_sasl ];

  checkInputs = [ pytest ];

  checkPhase = ''
    # Needed by tests to setup a mockup ldap server.
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"

    py.test
  '';

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Python modules for implementing LDAP clients";
    homepage = "https://www.python-ldap.org/";
    license = licenses.psfl;
  };
}
