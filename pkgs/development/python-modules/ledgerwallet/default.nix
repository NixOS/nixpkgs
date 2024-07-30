{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  cryptography,
  click,
  construct,
  ecdsa,
  hidapi,
  intelhex,
  pillow,
  protobuf,
  requests,
  setuptools,
  setuptools-scm,
  tabulate,
  toml,
  AppKit,
}:

buildPythonPackage rec {
  pname = "ledgerwallet";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "ledgerctl";
    rev = "v${version}";
    hash = "sha256-PBULYvyO3+YaW+a1/enJtKB/DR4ndL/o/WdpETbWyZ0=";
  };

  buildInputs = [
    setuptools
    setuptools-scm
  ] ++ lib.optionals stdenv.isDarwin [ AppKit ];
  propagatedBuildInputs = [
    cryptography
    click
    construct
    ecdsa
    hidapi
    intelhex
    pillow
    protobuf
    requests
    tabulate
    toml
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"protobuf >=3.20,<4"' '"protobuf >=3.20"'
  '';

  # Regenerate protobuf bindings to lift the version upper-bound and enable
  # compatibility the current default protobuf library.
  preBuild = ''
    protoc --python_out=. --pyi_out=. ledgerwallet/proto/*.proto
  '';

  pythonImportsCheck = [ "ledgerwallet" ];

  meta = with lib; {
    homepage = "https://github.com/LedgerHQ/ledgerctl";
    description = "Library to control Ledger devices";
    mainProgram = "ledgerctl";
    license = licenses.mit;
    maintainers = with maintainers; [
      d-xo
      erdnaxe
    ];
  };
}
