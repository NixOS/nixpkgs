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
  version = "0.1.47";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xe8ude2JzrdmJqwzqLlxRO697IjcGuQgGG6c3nQ/drg=";
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
