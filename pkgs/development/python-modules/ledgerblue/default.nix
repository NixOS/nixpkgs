{ stdenv, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket_client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1fc7ab685780309a7220c6ee517d88072cc594a9615bcc18e68ed5f149fa432";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex websocket_client
  ];

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
