{ lib
, buildPythonPackage
, fetchPypi
, setuptools
 }:

buildPythonPackage rec {
  pname = "ledgercomm";
  version = "1.1.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-izOPbwv+34Xq8mpq9+QRIGhd+z4pVnGJSMnYOktRVbs=";
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
