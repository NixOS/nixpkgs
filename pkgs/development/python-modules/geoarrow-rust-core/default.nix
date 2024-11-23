{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
  pkg-config,
  openssl,
  darwin,
  geodatasets,
  geopandas,
}:

buildPythonPackage rec {
  pname = "geoarrow-rust-core";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geoarrow";
    repo = "geoarrow-rs";
    rev = "refs/tags/rust-v${version}";
    hash = "sha256-trOVsQKFz0/YyggpUJ63YADAOu/77eFcVtv0w2A88H8=";
  };

  sourceRoot = "${src.name}/python/core";

  cargoDeps = rustPlatform.importCargoLock { lockFile = "${src}/python/core/Cargo.lock"; };

  build-system = [ rustPlatform.maturinBuildHook ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    pkg-config
  ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  dependencies = [
    geodatasets
    geopandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = false; # almost all tests rely on network to download data

  pythonImportsCheck = [ "geoarrow.rust.core" ];

  meta = {
    description = "Metapackage for geoarrow.rust namespace";
    homepage = "https://github.com/hukkin/mdformat-gfm";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
