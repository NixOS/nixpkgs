{ lib,
  buildPythonPackage,
  rustPlatform,

  fetchFromGitHub,

  krb5,
  openssl,

  libkrb5,
}:
buildPythonPackage rec {
  pname = "connectorx";
  version = "0.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sfu-db";
    repo = "connector-x";
    rev = "v${version}";
    hash = "sha256-L/tI2Lux+UnXZrpBxXX193pvb34hr5kqWo0Ncb1V+R0=";
  };

  sourceRoot = "${src.name}/connectorx-python";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-python-${version}";
    hash = "sha256-zeBYQXqCb/KXth+QG0n2yUZ1D6JNseEw+ru3xX04zts=";
  };

  env = {
    # needed for openssl-sys
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  nativeBuildInputs = [
    krb5 # needed for `krb5-config` during libgssapi-sys

    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libkrb5 # needed for libgssapi-sys
    openssl # needed for openssl-sys
  ];

  pythonImportsCheck = [ "connectorx" ];

  meta = {
    description = "Fastest library to load data from DB to DataFrames in Rust and Python";
    homepage = "https://sfu-db.github.io/connector-x";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ coastalwhite ];
  };
}
