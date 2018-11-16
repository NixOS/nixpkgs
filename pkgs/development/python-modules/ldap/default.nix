{ buildPythonPackage, fetchPypi
, pyasn1, pyasn1-modules, pytest
, openldap, cyrus_sasl, stdenv }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41975e79406502c092732c57ef0c2c2eb318d91e8e765f81f5d4ab6c1db727c5";
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
}
