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
  pythonOlder,
  setuptools,
  setuptools-scm,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "ledgerblue";
  version = "0.1.54";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hn99ST6RnER6XI6+rqA3O9/aC+whYoTOzeoHGF/fFz4=";
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
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bleak ];

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
