{ lib, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UNquetZ1sCLO9T5p5b3jTSu+52xuc5XdyHNKsvvPdck=";
  };

  propagatedBuildInputs = [
    hidapi pycrypto pillow protobuf future ecpy python-u2flib-host pycryptodomex websocket-client
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "ledgerblue" ];

  meta = with lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
