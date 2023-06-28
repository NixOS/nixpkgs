{ lib
, buildPythonPackage
, fetchPypi
, setuptools
 }:

buildPythonPackage rec {
  pname = "ledgercomm";
  version = "1.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HunJjIRa3IpSL/3pZPf6CroLxEK/l7ihh737VOAILgU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "ledgercomm"
  ];

  meta = with lib; {
    description = "Python library to send and receive APDU through HID or TCP socket. It can be used with a Ledger Nano S/X or with the Speculos emulator.";
    homepage = "https://github.com/LedgerHQ/ledgercomm";
    license = licenses.mit;
  };
}
