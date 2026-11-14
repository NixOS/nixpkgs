{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ledgercomm,
  packaging,
  bip32,
  coincurve,
  typing-extensions,
  hidapi,
}:

buildPythonPackage (finalAttrs: {
  pname = "ledger-bitcoin";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "ledger_bitcoin";
    hash = "sha256-kP9xdzY0jbf7BwZYu8lWU20kKMI7oicbwNp+yRVy7V8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    ledgercomm
    packaging
    bip32
    coincurve
    typing-extensions
    hidapi
  ];

  pythonImportsCheck = [ "ledger_bitcoin" ];

  meta = {
    description = "Client library for Ledger Bitcoin application";
    homepage = "https://github.com/LedgerHQ/app-bitcoin-new/tree/develop/bitcoin_client/ledger_bitcoin";
    license = lib.licenses.asl20;
  };
})
