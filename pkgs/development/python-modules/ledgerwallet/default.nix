<<<<<<< HEAD
{ lib
, stdenv
=======
{ lib, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, cryptography
, click
, construct
, ecdsa
<<<<<<< HEAD
, flit-core
, hidapi
, intelhex
, pillow
, protobuf3
, requests
, setuptools
, tabulate
, toml
=======
, hidapi
, intelhex
, pillow
, protobuf
, requests
, tabulate
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, AppKit
}:

buildPythonPackage rec {
  pname = "ledgerwallet";
<<<<<<< HEAD
  version = "0.2.4";
  format = "pyproject";
=======
  version = "0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "ledgerctl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-IcStYYkKEdZxwgJKL8l2Y1BtO/Oncd4aKUAZD8umbHs=";
  };

  buildInputs = [ flit-core setuptools ] ++ lib.optionals stdenv.isDarwin [ AppKit ];
  propagatedBuildInputs = [
    cryptography
    click
    construct
    ecdsa
    hidapi
    intelhex
    pillow
    protobuf3
    requests
    tabulate
    toml
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [ "ledgerwallet" ];

  meta = with lib; {
    homepage = "https://github.com/LedgerHQ/ledgerctl";
    description = "A library to control Ledger devices";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ d-xo erdnaxe ];
=======
    maintainers = with maintainers; [ d-xo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
