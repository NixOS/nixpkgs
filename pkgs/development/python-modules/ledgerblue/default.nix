{
  lib,
  stdenv,
  bleak,
  buildPythonPackage,
  ecpy,
  fetchPypi,
  hidapi,
  nfcpy,
  pillow,
  protobuf,
  pycrypto,
  pycryptodomex,
  pyelftools,
  pyserial,
  python-gnupg,
  python-u2flib-host,
  setuptools-scm,
  setuptools,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "ledgerblue";
  version = "0.1.58";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EHniiz6h6qoH8srquVaiWIxpTDQaKp9strNtuIpHeTY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "protobuf" ];

  pythonRemoveDeps = [ "future" ];

  dependencies = [
    ecpy
    hidapi
    nfcpy
    pillow
    protobuf
    pycrypto
    pycryptodomex
    pyelftools
    pyserial
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
    changelog = "https://github.com/LedgerHQ/blue-loader-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ np ];
  };
})
