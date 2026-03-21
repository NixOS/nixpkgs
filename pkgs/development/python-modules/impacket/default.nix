{
  lib,
  buildPythonPackage,
  charset-normalizer,
  dsinternals,
  fetchPypi,
  flask,
  ldap3,
  ldapdomaindump,
  pyasn1,
  pyasn1-modules,
  pycryptodomex,
  pyopenssl,
  setuptools,
  pytestCheckHook,
  six,
  writeText,
}:

let
  opensslConf = writeText "openssl.conf" ''
    openssl_conf = openssl_init

    [openssl_init]
    providers = provider_sect

    [provider_sect]
    default = default_sect
    legacy = legacy_sect

    [default_sect]
    activate = 1

    [legacy_sect]
    activate = 1
  '';
in
buildPythonPackage rec {
  pname = "impacket";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0JpSvvxU24IDM2BWfetwxIoIGBPQiiIhstGiWc1+Tjo=";
  };

  pythonRelaxDeps = [ "pyopenssl" ];

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    dsinternals
    flask
    ldap3
    ldapdomaindump
    pyasn1
    pyasn1-modules
    pycryptodomex
    pyopenssl
    setuptools
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  makeWrapperArgs = [ "--set-default OPENSSL_CONF ${opensslConf}" ];

  pythonImportsCheck = [
    "impacket"
    "impacket.msada_guids"
  ];

  disabledTestPaths = [
    # Skip all RPC related tests
    "tests/dcerpc/"
    "tests/SMB_RPC/"
  ];

  meta = {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/SecureAuthCorp/impacket";
    changelog =
      "https://github.com/fortra/impacket/releases/tag/impacket_"
      + lib.replaceStrings [ "." ] [ "_" ] version;
    # Modified Apache Software License, Version 1.1
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ fab ];
  };
}
