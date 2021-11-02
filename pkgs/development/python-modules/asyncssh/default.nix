{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cryptography
, bcrypt
, gssapi
, fido2
, libnacl
, libsodium
, nettle
, python-pkcs11
, pyopenssl
, openssl
, openssh
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "2.7.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96b09239c3cc134cfb66ae1138313fdb48cc390806f21f831dd44f8a1d8252a1";
  };

  propagatedBuildInputs = [
    bcrypt
    cryptography
    fido2
    gssapi
    libnacl
    libsodium
    nettle
    python-pkcs11
    pyopenssl
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
  ];

  pythonImportsCheck = [ "asyncssh" ];

  meta = with lib; {
    description = "Asynchronous SSHv2 Python client and server library";
    homepage = "https://asyncssh.readthedocs.io/";
    license = licenses.epl20;
    maintainers = with maintainers; [ ];
  };
}
