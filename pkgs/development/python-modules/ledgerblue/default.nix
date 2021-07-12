{ lib, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.35";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44fbd8fcf62430a6b84d4e826a9ef7fc21c77a7d8ff275f3952d6086ef06d076";
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
