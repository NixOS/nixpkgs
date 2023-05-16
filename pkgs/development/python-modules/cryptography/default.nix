{ lib
, stdenv
<<<<<<< HEAD
, buildPythonPackage
, callPackage
, cargo
, cffi
, fetchPypi
, hypothesis
, iso8601
, isPyPy
, libiconv
, libxcrypt
, openssl
, pkg-config
, pretend
, py
, pytest-subtests
, pytestCheckHook
, pythonOlder
, pytz
, rustc
, rustPlatform
, Security
, setuptoolsRustBuildHook
=======
, callPackage
, buildPythonPackage
, fetchPypi
, rustPlatform
, cargo
, rustc
, setuptools-rust
, openssl
, Security
, packaging
, six
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  cryptography-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
<<<<<<< HEAD
  version = "41.0.3"; # Also update the hash in vectors.nix
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bRknQRE+9eMNidy1uVbvThV48wRwhwG4tz044+FGHzQ=";
=======
  version = "40.0.1"; # Also update the hash in vectors.nix
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KAPy+LHpX2FEGZJsfm9V2CivxhTKXtYVQ4d65mjMNHI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-LQu7waympGUs+CZun2yDQd2gUUAgyisKBG5mddrfSo0=";
=======
    hash = "sha256-gFfDTc2QWBWHBCycVH1dYlCsWQMVcRZfOBIau+njtDU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-disable" ""
  '';

  cargoRoot = "src/rust";

<<<<<<< HEAD
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    setuptoolsRustBuildHook
    cargo
    rustc
    pkg-config
  ] ++ lib.optionals (!isPyPy) [
    cffi
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    libiconv
  ] ++ lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  nativeCheckInputs = [
    cryptography-vectors
<<<<<<< HEAD
    hypothesis
=======
    # "hypothesis" indirectly depends on cryptography to build its documentation
    (hypothesis.override { enableDocumentation = false; })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
      Our goal is for it to be your "cryptographic standard library". It
      supports Python 2.7, Python 3.5+, and PyPy 5.4+.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v"
      + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [ asl20 bsd3 psfl ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
