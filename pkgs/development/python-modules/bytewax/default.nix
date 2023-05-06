{ lib
, stdenv
, buildPythonPackage
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
}:

buildPythonPackage rec {
  pname = "bytewax";
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XdFkFhN8Z15Zw5HZ2wmnNFoTzyRtIbB7TAtOpKwuKyY=";
  };

  # Remove docs tests, myst-docutils in nixpkgs is not compatible with package requirements.
  # Package uses old version.
  patches = [ ./remove-docs-test.patch ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-XGE1qPHi13/+8jjNCIgfzPudw561T0vUfJv5xnKySAg=";
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

  preCheck = ''
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  checkInputs = [
    pytestCheckHook
    confluent-kafka
  ];

  meta = with lib; {
    description = "Python Stream Processing";
    homepage = "https://github.com/bytewax/bytewax";
    license = licenses.asl20;
    maintainers = with maintainers; [ mslingsby kfollesdal ];
    # mismatched type expected u8, found i8
    broken = stdenv.isAarch64;
  };
}
