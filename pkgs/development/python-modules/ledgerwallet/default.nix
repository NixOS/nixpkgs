{ lib, stdenv
, fetchFromGitHub
, buildPythonPackage
, cryptography
, click
, construct
, ecdsa
, hidapi
, intelhex
, pillow
, protobuf
, requests
, tabulate
, AppKit
}:

buildPythonPackage rec {
  pname = "ledgerwallet";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "ledgerctl";
    rev = "v${version}";
    sha256 = "0fb93h2wxm9as9rsywlgz2ng4wrlbjphn6mgbhj6nls2i86rrdxk";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit ];
  propagatedBuildInputs = [
    cryptography click construct ecdsa hidapi intelhex pillow protobuf requests tabulate
  ];

  pythonImportsCheck = [ "ledgerwallet" ];

  meta = with lib; {
    homepage = "https://github.com/LedgerHQ/ledgerctl";
    description = "A library to control Ledger devices";
    license = licenses.mit;
    maintainers = with maintainers; [ d-xo ];
  };
}
