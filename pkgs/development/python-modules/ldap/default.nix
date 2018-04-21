{ lib, buildPythonPackage, fetchPypi
, pyasn1, pyasn1-modules, pytest
, openldap, cyrus_sasl }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86746b912a2cd37a54b06c694f021b0c8556d4caeab75ef50435ada152e2fbe1";
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
}
