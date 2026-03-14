{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  openssl,
  sqlite,
  xz,
  pkgs,
  zlib,
  cargo,
  krb5,
  libkrb5,
  python,
  runCommand,
  pythonAtLeast,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "connector-x";
  version = "0.4.4";
  pyproject = true;
  disable = pythonAtLeast "3.10"; # As described in pyproject.toml

  src = fetchFromGitHub {
    owner = "sfu-db";
    repo = "connector-x";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NrXHkHTIulJ+BIqBp8OUAjm6pn58Z1bSJIuYH6lifuI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = finalAttrs.pname;
    version = finalAttrs.version;
    src = finalAttrs.src;
    cargoRoot = finalAttrs.cargoRoot;
    hash = "sha256-OojM/HzJmV3rW3Xb0zkSntx/Qhu/BbncpFUtrR38h4w=";
  };
  cargoRoot = "connectorx-python";

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
    rustPlatform.cargoInstallHook
    rustPlatform.bindgenHook
    (pkgs.__splicedPackages.krb5 or krb5) # Python consumes the original
  ];

  buildInputs = [
    (pkgs.__splicedPackages.zstd or pkgs.zstd) # Python also consumes this one...
    bzip2
    openssl
    sqlite
    xz
    zlib
    libkrb5
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    OPENSSL_NO_VENDOR = true;
  };

  maturinBuildFlags = [
    "-m"
    "connectorx-python/Cargo.toml"
  ];
  passthru.tests.import-test =
    runCommand "connectorx-import-check"
      {
        nativeBuildInputs = [
          (python.withPackages (ps: [
            ps.connector-x
            ps.pandas
          ]))
        ];
      }
      ''
        python -c "import connectorx; import pandas; print('Import successful!')"
        touch $out
      '';
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fastest library to load data from DB to DataFrames in Rust and Python";
    homepage = "https://github.com/sfu-db/connector-x";
    changelog = "https://github.com/sfu-db/connector-x/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deimelias ];
    mainProgram = "connector-x";
  };
})
