{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pyasn1
, pyasn1-modules
, pythonAtLeast
, pythonOlder
, pytestCheckHook
, openldap
, cyrus_sasl
}:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.4.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/python-ldap-${version}";
    hash = "sha256-/ehvSs2qjuTPhaaOP0agPbWyyRugBpUlPq/Ny9t2C58=";
  };

  buildInputs = [
    openldap
    cyrus_sasl
  ];

  propagatedBuildInputs = [
    pyasn1
    pyasn1-modules
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Needed by tests to setup a mockup ldap server.
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Python modules for implementing LDAP clients";
    homepage = "https://www.python-ldap.org/";
    license = licenses.psfl;
  };
}
