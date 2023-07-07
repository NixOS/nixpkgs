{ lib
, stdenv
, callPackage
, buildPythonPackage
, fetchPypi
, cargo
, cffi
, hypothesis
, isPyPy
, iso8601
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
, rustPlatform
, rustc
, Security
, setuptools
, setuptools-rust
}:

let
  cryptography-vectors = callPackage ./vectors.nix { };
in
buildPythonPackage rec {
  pname = "cryptography";
  version = "41.0.1"; # Also update the hash in vectors.nix
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-00V5CFQB0/SXYtL31mNNa2wq4SQiAuhg9NJrBG46EAY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-38q81vRf8QHR8lFRM2KbH7Ng5nY7nmtWRMoPWS9VO/U=";
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
    setuptools
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
    '';
    homepage = "https://github.com/pyca/cryptography";
    changelog = "https://cryptography.io/en/latest/changelog/#v"
      + replaceStrings [ "." ] [ "-" ] version;
    license = with licenses; [ asl20 bsd3 psfl ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
