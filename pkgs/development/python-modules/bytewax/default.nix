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
, dill
, multiprocess
, pytestCheckHook
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "bytewax";
  version = "0.15.1";
  format = "pyproject";

  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "bytewax";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4HZUu3WSrhxusvuVz8+8mndTu/9DML1tCH52eaWy+oE=";
  };

  # Remove docs tests, myst-docutils in nixpkgs is not compatible with package requirements.
  # Package uses old version.
  patches = [ ./remove-docs-test.patch ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-IfVX3k9AsqP84aagCLSwxmutUoEkP8haD+t+VY4V02U=";
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

  propagatedBuildInputs = [
    dill
    multiprocess
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python Stream Processing";
    homepage = "https://github.com/bytewax/bytewax";
    license = licenses.asl20;
    maintainers = with maintainers; [ mslingsby kfollesdal ];
    # mismatched type expected u8, found i8
    broken = stdenv.isAarch64;
  };
}
