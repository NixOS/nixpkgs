{
  lib,
  bcrypt,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  fido2,
  gssapi,
  libnacl,
  libsodium,
  nettle,
  openssh,
  openssl,
  pyopenssl,
  pytestCheckHook,
  python-pkcs11,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "2.14.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6Va/iYjQega6MwX2YE4mH0ygFMSiMvCHPxx2kvvjz8I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    nettle
    typing-extensions
  ];

  buildInputs = [ libsodium ];

  optional-dependencies = {
    bcrypt = [ bcrypt ];
    fido2 = [ fido2 ];
    gssapi = [ gssapi ];
    libnacl = [ libnacl ];
    pkcs11 = [ python-pkcs11 ];
    pyOpenSSL = [ pyopenssl ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    openssh
    openssl
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  patches = [
    # Reverts https://github.com/ronf/asyncssh/commit/4b3dec994b3aa821dba4db507030b569c3a32730
    #
    # This changed the test to avoid setting the sticky bit
    # because that's not allowed for plain files in FreeBSD.
    # However that broke the test on NixOS, failing with
    # "Operation not permitted"
    ./fix-sftp-chmod-test-nixos.patch
  ];

  disabledTestPaths = [
    # Disables windows specific test (specifically the GSSAPI wrapper for Windows)
    "tests/sspi_stub.py"
  ];

  disabledTests = [
    # No PIN set
    "TestSKAuthCTAP2"
    # Requires network access
    "test_connect_timeout_exceeded"
    # Fails in the sandbox
    "test_forward_remote"
  ];

  pythonImportsCheck = [ "asyncssh" ];

  meta = with lib; {
    description = "Asynchronous SSHv2 Python client and server library";
    homepage = "https://asyncssh.readthedocs.io/";
    changelog = "https://github.com/ronf/asyncssh/blob/v${version}/docs/changes.rst";
    license = licenses.epl20;
    maintainers = with maintainers; [ ];
  };
}
