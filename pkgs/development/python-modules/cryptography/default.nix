{ lib
, stdenv
, callPackage
, buildPythonPackage
, fetchPypi
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
, py
, pytz
, hypothesis
}:

let
  cryptography-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
  version = "38.0.4"; # Also update the hash in vectors.nix
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F1wagYuHyayAu3N39VILfzGz7yoABOJCAxm+re22cpA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-BN0kOblUwgHj5QBf52RY2Jx0nBn03lwoN1O5PEohbwY=";
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
    # "hypothesis" indirectly depends on cryptography to build its documentation
    (hypothesis.override { enableDocumentation = false; })
    iso8601
    pretend
    py
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
