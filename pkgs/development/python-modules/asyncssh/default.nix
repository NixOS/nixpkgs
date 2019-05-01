{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl
, openssl }:

let
  # asyncssh requires openssl 1.1.x for ec25519 support, but the default cryptography and
  # pyopenssl packages are built against openssl 1.0.x. to enable ec25519 support, supply
  # this package with a 1.1.x openssl package. note however that this may produce package
  # collisions with (and not be installable in the same environment as) any of the python
  # packages that depend on the default cryptography or pyopenssl.
  cryptography' = (cryptography.override { inherit openssl; });
  pyopenssl' = (pyopenssl.override { inherit openssl; cryptography = cryptography'; });
in buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.16.1";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qia1ay2dhwps5sfh0hif7mrv7yxvykxs9l7cmfp4m6hmqnn3r5r";
  };

  propagatedBuildInputs = [
    bcrypt
    cryptography'
    gssapi
    libnacl
    libsodium
    nettle
    pyopenssl'
  ];

  checkInputs = [ openssl ];

  # Disables windows specific test (specifically the GSSAPI wrapper for Windows) and
  # prevents sftp test from attempting to set permission bits which we're not allowed
  # to in the sandbox environment.
  postPatch = ''
    rm ./tests/sspi_stub.py
    substituteInPlace ./tests/test_sftp.py --replace "0o4321" "0o321"
  '';

  meta = with stdenv.lib; {
    description = "Provides an asynchronous client and server implementation of the SSHv2 protocol on top of the Python asyncio framework";
    homepage    = https://pypi.python.org/pypi/asyncssh;
    license     = licenses.epl20;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
