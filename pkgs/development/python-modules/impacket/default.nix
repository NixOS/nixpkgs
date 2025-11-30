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
}:

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

  pythonImportsCheck = [ "impacket" ];

  disabledTestPaths = [
    # Skip all RPC related tests
    "tests/dcerpc/"
    "tests/SMB_RPC/"
  ];

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/SecureAuthCorp/impacket";
    changelog =
      "https://github.com/fortra/impacket/releases/tag/impacket_"
      + replaceStrings [ "." ] [ "_" ] version;
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ fab ];
  };
}
