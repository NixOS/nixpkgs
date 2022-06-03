{ stdenv
, lib
, bcrypt
, buildPythonPackage
, cryptography
, fetchPypi
, fido2
, gssapi
, libnacl
, libsodium
, nettle
, openssh
, openssl
, pyopenssl
, pytestCheckHook
, python-pkcs11
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "2.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SZuDbPWKnxknrStaQMPL0N042+CNLfj6is1TjCj8j6k=";
  };

  propagatedBuildInputs = [
    bcrypt
    cryptography
    fido2
    gssapi
    libnacl
    libsodium
    nettle
    pyopenssl
    python-pkcs11
    typing-extensions
  ];

  checkInputs = [
    openssh
    openssl
    pytestCheckHook
  ];

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

  pythonImportsCheck = [
    "asyncssh"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Asynchronous SSHv2 Python client and server library";
    homepage = "https://asyncssh.readthedocs.io/";
    license = licenses.epl20;
    maintainers = with maintainers; [ ];
  };
}
