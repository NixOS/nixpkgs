{ lib
, stdenv
, buildPythonPackage
, callPackage
, cargo
, certifi
, cffi
, cryptography-vectors ? (callPackage ./vectors.nix { })
, fetchPypi
, fetchpatch2
, isPyPy
, libiconv
, libxcrypt
, openssl
, pkg-config
, pretend
, pytest-xdist
, pytestCheckHook
, pythonOlder
, rustc
, rustPlatform
, Security
, setuptoolsRustBuildHook
}:

buildPythonPackage rec {
  pname = "cryptography";
  version = "42.0.5"; # Also update the hash in vectors.nix
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b+B+7JXf1HfrlTCu9b6tNP7IGbOq9sW9bSBWXaYHv+E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${pname}-${version}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-Pw3ftpcDMfZr/w6US5fnnyPVsFSB9+BuIKazDocYjTU=";
  };

  patches = [
    (fetchpatch2 {
      # skip overflowing tests on 32 bit; https://github.com/pyca/cryptography/pull/10366
      url = "https://github.com/pyca/cryptography/commit/d741901dddd731895346636c0d3556c6fa51fbe6.patch";
      hash = "sha256-eC+MZg5O8Ia5CbjRE4y+JhaFs3Q5c62QtPHr3x9T+zw=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--benchmark-disable" ""
  '';

  cargoRoot = "src/rust";

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

  propagatedBuildInputs = lib.optionals (!isPyPy) [
    cffi
  ];

  nativeCheckInputs = [
    certifi
    cryptography-vectors
    pretend
    pytestCheckHook
    pytest-xdist
  ];

  pytestFlagsArray = [
    "--disable-pytest-warnings"
  ];

  disabledTestPaths = [
    # save compute time by not running benchmarks
    "tests/bench"
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
