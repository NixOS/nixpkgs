{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl
, openssl }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.14.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f1i5a760a3jylkj00bxkshnylzyhyqz50v8mb8s9ygllpzja058";
  };

  propagatedBuildInputs = [
    bcrypt
    cryptography
    gssapi
    libnacl
    libsodium
    nettle
    pyopenssl
  ];

  checkInputs = [ openssl ];

  # Disables windows specific test (specifically the GSSAPI wrapper for Windows)
  postPatch = ''
    rm ./tests/sspi_stub.py
  '';

  meta = with stdenv.lib; {
    description = "Provides an asynchronous client and server implementation of the SSHv2 protocol on top of the Python asyncio framework";
    homepage    = https://pypi.python.org/pypi/asyncssh;
    license     = licenses.epl20;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
