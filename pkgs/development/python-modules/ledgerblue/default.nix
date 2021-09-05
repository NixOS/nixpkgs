{ lib, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.37";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f34945c9bd4b9846ed9e48ecc239d3e9aec64c3a45411092d133260246169854";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex websocket-client
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
