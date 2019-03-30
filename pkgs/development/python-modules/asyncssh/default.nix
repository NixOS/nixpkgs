{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, fetchpatch
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl
, openssl, openssh }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.16.1";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qia1ay2dhwps5sfh0hif7mrv7yxvykxs9l7cmfp4m6hmqnn3r5r";
  };

  patches = [
    # Reverts https://github.com/ronf/asyncssh/commit/4b3dec994b3aa821dba4db507030b569c3a32730
    #
    # This changed the test to avoid setting the sticky bit
    # because that's not allowed for plain files in FreeBSD.
    # However that broke the test on NixOS, failing with
    # "Operation not permitted"
    ./fix-sftp-chmod-test-nixos.patch

    # Restore libnacl support for curve25519/ed25519 as a fallback for PyCA
    # Fixes https://github.com/ronf/asyncssh/issues/206 with older openssl
    (fetchpatch {
      url = "https://github.com/ronf/asyncssh/commit/1dee113bb3e4a6888de562b0413e9abd6a0f0f04.patch";
      sha256 = "04bckdj7i6xk24lizkn3a8cj375pkz7yc57fc0vk222c6jzwzaml";
    })
  ];

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
  ];

  # Disables windows specific test (specifically the GSSAPI wrapper for Windows)
  postPatch = ''
    rm tests/sspi_stub.py
  '';

  meta = with stdenv.lib; {
    description = "Provides an asynchronous client and server implementation of the SSHv2 protocol on top of the Python asyncio framework";
    homepage = https://asyncssh.readthedocs.io/en/latest;
    license = licenses.epl20;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
