{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, ledgercomm
, packaging
, typing-extensions
 }:

buildPythonPackage rec {
  pname = "ledger-bitcoin";
  version = "0.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "ledger_bitcoin";
    hash = "sha256-AWl/q2MzzspNIo6yf30S92PgM/Ygsb+1lJsg7Asztso=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ledgercomm
    packaging
    typing-extensions
  ];

  pythonImportsCheck = [
    "ledger_bitcoin"
  ];

  meta = with lib; {
    description = "Client library for Ledger Bitcoin application.";
    homepage = "https://github.com/LedgerHQ/app-bitcoin-new/tree/develop/bitcoin_client/ledger_bitcoin";
    license = licenses.asl20;
  };
}
