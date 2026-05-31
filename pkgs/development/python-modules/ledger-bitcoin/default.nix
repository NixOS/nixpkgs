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
}:

buildPythonPackage (finalAttrs: {
  pname = "ledger-bitcoin";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "ledger_bitcoin";
    hash = "sha256-PLQpftflV++YNJzcvWZ+9zaMBH1oGMfNy8p6+YuABrY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    ledgercomm
    packaging
    bip32
    coincurve
    typing-extensions
  ];

  pythonImportsCheck = [ "ledger_bitcoin" ];

  meta = {
    description = "Client library for Ledger Bitcoin application";
    homepage = "https://github.com/LedgerHQ/app-bitcoin-new/tree/develop/bitcoin_client/ledger_bitcoin";
    license = lib.licenses.asl20;
  };
})
