{ lib, fetchPypi, buildPythonPackage, hidapi
, pycrypto, pillow, protobuf, future, ecpy, python-u2flib-host, pycryptodomex
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.41";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7246a1a0442a63aff0b5de2796d306f0033e1937b3c9b9c2a92c9101cde4fe8d";
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
