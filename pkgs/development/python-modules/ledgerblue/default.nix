{ lib
, stdenv
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
, python-gnupg
, python-u2flib-host
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, setuptools-scm
, websocket-client
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.50";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0SzUy0mPEbgeoOKEa9UtrjAQafrauKl1wvsONyosJNk=";
  };

  build-system = [
    setuptools
    setuptools-scm
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    ecpy
    future
    hidapi
    nfcpy
    pillow
    protobuf
    pycrypto
    pycryptodomex
    pyelftools
    python-gnupg
    python-u2flib-host
    websocket-client
  ]
  ++ lib.optionals stdenv.isLinux [
    bleak
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
