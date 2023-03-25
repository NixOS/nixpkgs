{ lib, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      # Fix removed function in construct library
      url = "https://github.com/LedgerHQ/ledgerctl/commit/fd23d0e14721b93789071e80632e6bd9e47c1256.patch";
      hash = "sha256-YNlENguPQW5FNFT7mqED+ghF3TJiKao4H+56Eu+j+Eo=";
      excludes = [ "setup.py" ];
    })
  ];

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
