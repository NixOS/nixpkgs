{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  rocksdb,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-backend-filesystem";
  version = "1.10.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-filesystem";
    tag = finalAttrs.version;
    hash = "sha256-NJ++v4i47nOAKZim1AYsiMCNHFW57o4tyalAjc7Eetg=";
  };

  cargoHash = "sha256-ijjNptt8ybKlwsDOmcyLATtAE+czsjnBy/Q4NwvWoHE=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Backend and Storages for zenoh using the file system";
    homepage = "https://github.com/eclipse-zenoh/zenoh-backend-filesystem";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
