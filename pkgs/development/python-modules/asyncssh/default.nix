{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.13.1";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a44736830741e2bb9c4e3992819288b77ac4af217a46d12f415bb57c18ed9c22";
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

  # Disables windows specific test (specifically the GSSAPI wrapper for Windows)
  postPatch = ''
    rm ./tests/sspi_stub.py
  '';

  meta = with stdenv.lib; {
    description = "Provides an asynchronous client and server implementation of the SSHv2 protocol on top of the Python asyncio framework";
    homepage = https://pypi.python.org/pypi/asyncssh;
    license = licenses.epl10;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
