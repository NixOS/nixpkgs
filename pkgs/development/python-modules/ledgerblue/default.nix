{ lib
, bleak
, buildPythonPackage
, ecpy
, fetchPypi
, future
, hidapi
, nfcpy
, pillow
, protobuf
, pycrypto
, pycryptodomex
, pyelftools
, python-u2flib-host
, pythonOlder
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.48";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LVRNcsTmJOR3zTBhbKV4V0zCQk0sk/Uf6kSmfbAhgfY=";
  };

  propagatedBuildInputs = [
    bleak
    ecpy
    future
    hidapi
    nfcpy
    pillow
    protobuf
    pycrypto
    pycryptodomex
    pyelftools
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
