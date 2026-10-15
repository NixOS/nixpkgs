{
  lib,
  stdenv,
  bleak,
  buildPythonPackage,
  ecpy,
  fetchPypi,
  future,
  hidapi,
  nfcpy,
  pillow,
  protobuf,
  pycrypto,
  pycryptodomex,
  pyelftools,
  python-gnupg,
  python-u2flib-host,
  setuptools,
  setuptools-scm,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.55";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6s2V8cXik6jEg8z3UK49qVwodPbwXMIkWk7iJ7OY0rM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "protobuf" ];

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
  ++ lib.optionals stdenv.hostPlatform.isLinux [ bleak ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "ledgerblue" ];

  meta = {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ np ];
  };
}
