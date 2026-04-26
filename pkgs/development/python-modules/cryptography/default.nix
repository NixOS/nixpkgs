{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  setuptools,
  bcrypt,
  certifi,
  cffi,
  cryptography-vectors ? (callPackage ./vectors.nix { }),
  fetchFromGitHub,
  isPyPy,
  libiconv,
  openssl,
  pkg-config,
  pretend,
  pytest-xdist,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "47.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyca";
    repo = "cryptography";
    tag = version;
    hash = "sha256-XmTsD5vVFi+q9gf5lMqro5OcWhgRX573cc4gUozA1Hs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-RpNSJ4WKnKtqzR1qs223DAM4i0etb4ddL1lZ+PeduVU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--benchmark-disable" ""
  '';

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
    setuptools
  ]
  ++ lib.optionals (!isPyPy) [ cffi ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  dependencies = lib.optionals (!isPyPy) [ cffi ];

  optional-dependencies.ssh = [ bcrypt ];

  nativeCheckInputs = [
    certifi
    cryptography-vectors
    pretend
    pytestCheckHook
    pytest-xdist
  ]
  ++ optional-dependencies.ssh;

  pytestFlags = [ "--disable-pytest-warnings" ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
  ];

  passthru = {
    vectors = cryptography-vectors;
  };

  meta = {
    description = "Package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v" + lib.replaceString "." "-" version;
    license = with lib.licenses; [
      asl20
      bsd3
      psfl
    ];
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
