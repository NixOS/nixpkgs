{ lib, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl
, openssl, openssh, pytestCheckHook }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "2.5.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b65e2af73a2e39a271bd627abbe4f7e4b0345486ed403e65987d79c72fcb70b";
  };

  patches = [
    # Reverts https://github.com/ronf/asyncssh/commit/4b3dec994b3aa821dba4db507030b569c3a32730
    #
    # This changed the test to avoid setting the sticky bit
    # because that's not allowed for plain files in FreeBSD.
    # However that broke the test on NixOS, failing with
    # "Operation not permitted"
    ./fix-sftp-chmod-test-nixos.patch
  ];

  # Disables windows specific test (specifically the GSSAPI wrapper for Windows)
  postPatch = ''
    rm tests/sspi_stub.py
  '';

  propagatedBuildInputs = [
    bcrypt
    cryptography
    gssapi
    libnacl
    libsodium
    nettle
    pyopenssl
  ];

  checkInputs = [
    openssh
    openssl
    pytestCheckHook
  ];

  disabledTests = [ "test_expired_root" "test_confirm" ];

  meta = with lib; {
    description = "Provides an asynchronous client and server implementation of the SSHv2 protocol on top of the Python asyncio framework";
    homepage = "https://asyncssh.readthedocs.io/en/latest";
    license = licenses.epl20;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
