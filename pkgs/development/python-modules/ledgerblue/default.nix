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
<<<<<<< HEAD
  version = "0.1.48";
=======
  version = "0.1.47";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-LVRNcsTmJOR3zTBhbKV4V0zCQk0sk/Uf6kSmfbAhgfY=";
=======
    hash = "sha256-xe8ude2JzrdmJqwzqLlxRO697IjcGuQgGG6c3nQ/drg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
