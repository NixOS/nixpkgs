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
  version = "0.1.43";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t0mdw8cBGUZ33BWOSeEHyFAGga/Tf1F/gATFSfCpAJQ=";
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
