{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl
, openssl }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.15.1";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2065a8b3af0c514c8de264e7b01f08df5213b707bacb7e7c080bd46c3e3bc35";
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
