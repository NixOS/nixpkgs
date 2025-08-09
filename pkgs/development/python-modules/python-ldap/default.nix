{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  distutils,
  setuptools,

  # native dependencies
  openldap,
  cyrus_sasl,

  pyasn1,
  pyasn1-modules,

  # tests
  pytestCheckHook,
  jaraco-functools,
}:

buildPythonPackage rec {
  pname = "python-ldap";
  version = "3.4.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-ldap";
    repo = "python-ldap";
    tag = "python-ldap-${version}";
    hash = "sha256-v1cWoRGxbvvFnHqnwoIfmiQQcxfaA8Bf3+M5bE5PtuU=";
  };

  build-system = [
    distutils
    setuptools
  ];

  buildInputs = [
    openldap
    cyrus_sasl
  ];

  dependencies = [
    pyasn1
    pyasn1-modules
  ];

  nativeCheckInputs = [
    jaraco-functools
    pytestCheckHook
  ];

  preCheck = ''
    # Needed by tests to setup a mockup ldap server.
    export BIN="${openldap}/bin"
    export SBIN="${openldap}/bin"
    export SLAPD="${openldap}/libexec/slapd"
    export SCHEMA="${openldap}/etc/schema"
  '';

  disabledTests = [
    # https://github.com/python-ldap/python-ldap/issues/501
    "test_tls_ext_noca"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python modules for implementing LDAP clients";
    downloadPage = "https://github.com/python-ldap/python-ldap";
    homepage = "https://www.python-ldap.org/";
    changelog = "https://github.com/python-ldap/python-ldap/releases/tag/python-ldap-${version}";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
