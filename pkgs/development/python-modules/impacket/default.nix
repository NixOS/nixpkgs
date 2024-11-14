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
  pythonOlder,
  setuptools,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iVh9G4NqUiDXSEjJNHV5YrOCiG3KixtKDETWk/JgBkM=";
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
