{
  lib,
  stdenv,
  bleak,
  buildPythonPackage,
  ecpy,
  fetchpatch,
  fetchPypi,
  hidapi,
  nfcpy,
  pillow,
  protobuf,
  pycrypto,
  pycryptodomex,
  pyelftools,
  python-gnupg,
  python-u2flib-host,
  pythonOlder,
  setuptools,
  setuptools-scm,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.55";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6s2V8cXik6jEg8z3UK49qVwodPbwXMIkWk7iJ7OY0rM=";
  };

  patches = [
    (fetchpatch {
      name = "ledgerblue-no-future.patch";
      url = "https://github.com/LedgerHQ/blue-loader-python/commit/40a9904933bbf9d9bb50f20b942215725e2f8e2c.patch";
      hash = "sha256-6FIHeB6ReqvMKX20K33DuKk39E/FPsq59ah2Zf3Nt8I=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = [
    ecpy
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

  meta = with lib; {
    description = "Python library to communicate with Ledger Blue/Nano S";
    homepage = "https://github.com/LedgerHQ/blue-loader-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ np ];
  };
}
