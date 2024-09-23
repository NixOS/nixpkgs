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
  fetchPypi,
  isPyPy,
  libiconv,
  libxcrypt,
  openssl,
  pkg-config,
  pretend,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rustPlatform,
  Security,
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "43.0.0"; # Also update the hash in vectors.nix
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uIB1raLVGqnxgoNTLJ9g5yFwBBu6iNfzfknLsQJ1KZ4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-TEQy8PrIaZshiBFTqR/OJp3e/bVM1USjcmpDYcjPJPM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--benchmark-disable" ""
  '';

  cargoRoot = "src/rust";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
    setuptools
  ] ++ lib.optionals (!isPyPy) [ cffi ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      Security
      libiconv
    ]
    ++ lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  dependencies = lib.optionals (!isPyPy) [ cffi ];

  optional-dependencies.ssh = [ bcrypt ];

  nativeCheckInputs = [
    certifi
    cryptography-vectors
    pretend
    pytestCheckHook
    pytest-xdist
  ] ++ optional-dependencies.ssh;

  pytestFlagsArray = [ "--disable-pytest-warnings" ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
  ];

  passthru = {
    vectors = cryptography-vectors;
  };

  meta = with lib; {
    description = "Package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog =
      "https://cryptography.io/en/latest/changelog/#v" + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [
      asl20
      bsd3
      psfl
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
