{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  cryptography,
  click,
  construct,
  ecdsa,
  flit-core,
  hidapi,
  intelhex,
  pillow,
  protobuf3,
  requests,
  setuptools,
  tabulate,
  toml,
  AppKit,
}:

buildPythonPackage rec {
  pname = "ledgerwallet";
  version = "0.2.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "ledgerctl";
    rev = "v${version}";
    hash = "sha256-IcStYYkKEdZxwgJKL8l2Y1BtO/Oncd4aKUAZD8umbHs=";
  };

  buildInputs = [
    flit-core
    setuptools
  ] ++ lib.optionals stdenv.isDarwin [ AppKit ];
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
  ];

  pythonImportsCheck = [ "ledgerwallet" ];

  meta = with lib; {
    homepage = "https://github.com/LedgerHQ/ledgerctl";
    description = "A library to control Ledger devices";
    mainProgram = "ledgerctl";
    license = licenses.mit;
    maintainers = with maintainers; [
      d-xo
      erdnaxe
    ];
  };
}
