{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  krb5-c,
  openssl,
  libkrb5,
}:
buildPythonPackage rec {
  pname = "connectorx";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sfu-db";
    repo = "connector-x";
    tag = "v${version}";
    hash = "sha256-NqkLM5AZcFu3WMR2cx0zfVtvv0p4bes3c9l0UburjHI=";
  };

  sourceRoot = "${src.name}/connectorx-python";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-python-${version}";
    hash = "sha256-SCoL0X2ILAy/PAEyy9Ycb8kYcf3zokg7jcvr96NNHAI=";
  };

  env = {
    # needed for openssl-sys
    OPENSSL_NO_VENDOR = 1;
    OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
    OPENSSL_DIR = "${lib.getDev openssl}";
  };

  build-system = [
    rustPlatform.maturinBuildHook
  ];

  nativeBuildInputs = [
    krb5-c # needed for `krb5-config` during libgssapi-sys

    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libkrb5 # needed for libgssapi-sys
    openssl # needed for openssl-sys
  ];

  # copied from deltalake
  preCheck = ''
    # In tests we want to use connectorx that we have built
    rm -rf connectorx
  '';
  pythonImportsCheck = [ "connectorx" ];

  meta = {
    description = "Fastest library to load data from DB to DataFrames in Rust and Python";
    homepage = "https://sfu-db.github.io/connector-x";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ coastalwhite ];
  };
}
