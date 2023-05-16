{ lib
, stdenv
, buildPythonPackage
<<<<<<< HEAD
, cmake
, confluent-kafka
, cyrus_sasl
, fetchFromGitHub
, openssl
, pkg-config
, protobuf
, pytestCheckHook
, pythonOlder
, rustPlatform
, setuptools-rust
=======
, fetchFromGitHub
, rustPlatform
, setuptools-rust
, openssl
, pkg-config
, cyrus_sasl
, protobuf
, cmake
, gcc
, confluent-kafka
, pytestCheckHook
, pythonAtLeast
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "bytewax";
<<<<<<< HEAD
  version = "0.16.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";
=======
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonAtLeast "3.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-PHjKEZMNhtLliOSGt4XHQFDm8Rc4TejQUVSqFN6Au38=";
  };

  env = {
    OPENSSL_NO_VENDOR = true;
=======
    rev = "v${version}";
    hash = "sha256-XdFkFhN8Z15Zw5HZ2wmnNFoTzyRtIbB7TAtOpKwuKyY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Remove docs tests, myst-docutils in nixpkgs is not compatible with package requirements.
  # Package uses old version.
  patches = [ ./remove-docs-test.patch ];

<<<<<<< HEAD
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "columnation-0.1.0" = "sha256-RAyZKR+sRmeWGh7QYPZnJgX9AtWqmca85HcABEFUgX8=";
      "timely-0.12.0" = "sha256-sZuVLBDCXurIe38m4UAjEuFeh73VQ5Jawy+sr3U/HbI=";
    };
=======
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-XGE1qPHi13/+8jjNCIgfzPudw561T0vUfJv5xnKySAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    openssl
    cyrus_sasl
    protobuf
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    kafka = [
      confluent-kafka
    ];
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  checkInputs = [
    pytestCheckHook
<<<<<<< HEAD
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "bytewax"
=======
    confluent-kafka
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Python Stream Processing";
    homepage = "https://github.com/bytewax/bytewax";
<<<<<<< HEAD
    changelog = "https://github.com/bytewax/bytewax/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ mslingsby kfollesdal ];
    # mismatched type expected u8, found i8
    broken = stdenv.isAarch64;
  };
}
