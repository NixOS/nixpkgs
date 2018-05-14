{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.12.2";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "154zgl527dach974w8fad0aw326rnhxsrx79svad8vz7wn4dycv9";
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
