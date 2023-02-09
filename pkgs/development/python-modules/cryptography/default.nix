{ lib
, stdenv
, callPackage
, buildPythonPackage
, fetchPypi
, fetchpatch
, rustPlatform
, setuptools-rust
, openssl
, Security
, packaging
, six
, isPyPy
, cffi
, pytestCheckHook
, pytest-benchmark
, pytest-subtests
, pythonOlder
, pretend
, libiconv
, iso8601
, pytz
, hypothesis
}:

let
  cryptography-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
  version = "38.0.1"; # Also update the hash in vectors.nix
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HbPYB6FJMfoxf5ZDVpXZ7Dhr57hLYYzGHPpdCLCuM9c=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/advisories/GHSA-w7pp-m8wf-vj6r
      name = "CVE-2023-23931.patch";
      url = "https://github.com/pyca/cryptography/commit/94a50a9731f35405f0357fa5f3b177d46a726ab3.patch";
      hash = "sha256-Tc7yHQdY6zEYHlaZ75yh+L6OOos6VDXgLNPS5dttiUY=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-o8l13fnfEUvUdDasq3LxSPArozRHKVsZfQg9DNR6M6Q=";
  };

  cargoRoot = "src/rust";

  nativeBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ] ++ [
    rustPlatform.cargoSetupHook
    setuptools-rust
  ] ++ (with rustPlatform; [ rust.cargo rust.rustc ]);

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv ];

  propagatedBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  checkInputs = [
    cryptography-vectors
    hypothesis
    iso8601
    pretend
    pytestCheckHook
    pytest-benchmark
    pytest-subtests
    pytz
  ];

  pytestFlagsArray = [
    "--disable-pytest-warnings"
  ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
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
