{ lib
, buildPythonPackage
, charset-normalizer
, dsinternals
, fetchPypi
, flask
, ldap3
, ldapdomaindump
, pyasn1
, pycryptodomex
, pyopenssl
, pythonOlder
, setuptools
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "impacket";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7kA5tNKu3o9fZEeLxZ+qyGA2eWviTeqNwY8An7CQXko=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    charset-normalizer
    dsinternals
    flask
    ldap3
    ldapdomaindump
    pyasn1
    pycryptodomex
    pyopenssl
    setuptools
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "impacket"
  ];

  disabledTestPaths = [
    # Skip all RPC related tests
    "tests/dcerpc/"
    "tests/SMB_RPC/"
  ];

  meta = with lib; {
    description = "Network protocols Constructors and Dissectors";
    homepage = "https://github.com/SecureAuthCorp/impacket";
    changelog = "https://github.com/fortra/impacket/releases/tag/impacket_"
      + replaceStrings [ "." ] [ "_" ] version;
    # Modified Apache Software License, Version 1.1
    license = licenses.free;
    maintainers = with maintainers; [ fab ];
  };
}
