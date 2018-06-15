{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, cryptography
, bcrypt, gssapi, libnacl, libsodium, nettle, pyopenssl }:

buildPythonPackage rec {
  pname = "asyncssh";
  version = "1.13.0";
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n75z4dvhzymd4n610dpwlq7wl8cyz1gxx9m7iq92pzhss5vgpfd";
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
