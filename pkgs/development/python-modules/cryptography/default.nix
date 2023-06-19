{ lib
, stdenv
, callPackage
, buildPythonPackage
, fetchPypi
, rustPlatform
, cargo
, rustc
, setuptools-rust
, openssl
, Security
, isPyPy
, cffi
, pkg-config
, pytestCheckHook
, pytest-subtests
, pythonOlder
, pretend
, libiconv
, libxcrypt
, iso8601
, py
, pytz
, hypothesis
}:

let
  cryptography-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
  version = "40.0.1"; # Also update the hash in vectors.nix
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KAPy+LHpX2FEGZJsfm9V2CivxhTKXtYVQ4d65mjMNHI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-gFfDTc2QWBWHBCycVH1dYlCsWQMVcRZfOBIau+njtDU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-disable" ""
  '';

  cargoRoot = "src/rust";

  nativeBuildInputs = lib.optionals (!isPyPy) [
    cffi
    pkg-config
  ] ++ [
    rustPlatform.cargoSetupHook
    setuptools-rust
    cargo
    rustc
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv ]
    ++ lib.optionals (pythonOlder "3.9") [ libxcrypt ];

  propagatedBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  nativeCheckInputs = [
    cryptography-vectors
    hypothesis
    iso8601
    pretend
    py
    pytestCheckHook
    pytest-subtests
    pytz
  ];

  pytestFlagsArray = [
    "--disable-pytest-warnings"
  ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # aarch64-darwin forbids W+X memory, but this tests depends on it:
    # * https://cffi.readthedocs.io/en/latest/using.html#callbacks
    "tests/hazmat/backends/test_openssl_memleak.py"
  ];

  meta = with lib; {
    description = "A package which provides cryptographic recipes and primitives";
    longDescription = ''
      Cryptography includes both high level recipes and low level interfaces to
      common cryptographic algorithms such as symmetric ciphers, message
      digests, and key derivation functions.
      Our goal is for it to be your "cryptographic standard library". It
      supports Python 2.7, Python 3.5+, and PyPy 5.4+.
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v"
      + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [ asl20 bsd3 psfl ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
