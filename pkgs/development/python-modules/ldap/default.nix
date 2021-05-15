{ buildPythonPackage, fetchPypi
, pyasn1, pyasn1-modules
, pythonAtLeast, pytestCheckHook
, openldap, cyrus_sasl, lib, stdenv }:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "198as30xy6p760niqps2zdvq2xcmr765h06pmda8fa9y077wl4a7";
  };

  propagatedBuildInputs = [ pyasn1 pyasn1-modules ];

  checkInputs = [ pytestCheckHook ];
  buildInputs = [ openldap cyrus_sasl ];

  preCheck = ''
    # Needed by tests to setup a mockup ldap server.
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.9") [
    # See https://github.com/python-ldap/python-ldap/issues/407
    "test_simple_bind_noarg"
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Python modules for implementing LDAP clients";
    homepage = "https://www.python-ldap.org/";
    license = licenses.psfl;
  };
}
