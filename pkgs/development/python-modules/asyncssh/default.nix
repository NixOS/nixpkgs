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
  version = "2.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GFAT2OZ3R8PA8BtyQWuL14QX2h30jHH3baU8YH71QbY=";
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

  pythonImportsCheck = [ "asyncssh" ];

  meta = with lib; {
    description = "Asynchronous SSHv2 Python client and server library";
    homepage = "https://asyncssh.readthedocs.io/";
    license = licenses.epl20;
    maintainers = with maintainers; [ ];
  };
}
