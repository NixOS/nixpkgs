{ lib
, buildPythonPackage
, ecpy
, fetchPypi
, future
, hidapi
, pillow
, protobuf
, pycrypto
, pycryptodomex
, pythonOlder
, python-u2flib-host
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.44";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pOLpeej10G7Br8juTuQOSuCbhMjAP4aY0/JwnmJRblk=";
  };

  propagatedBuildInputs = [
    ecpy
    future
    hidapi
    pillow
    protobuf
    pycrypto
    pycryptodomex
    python-u2flib-host
    websocket-client
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "ledgerblue"
  ];

  meta = with lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
