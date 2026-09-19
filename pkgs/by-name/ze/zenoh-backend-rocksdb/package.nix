{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  rocksdb_10_10,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-backend-rocksdb";
  version = "1.10.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-rocksdb";
    tag = finalAttrs.version;
    hash = "sha256-m4Tnos5o/iBfJ+06ajUjJ51DFjYIvrwjgUsfRKHSWRc=";
  };

  cargoHash = "sha256-QF3ojTyMsxxlxkQXNxcokqiv8InQ2iRAwqtz84fDefE=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb_10_10}/include";
    ROCKSDB_LIB_DIR = "${rocksdb_10_10}/lib";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Backend and Storages for zenoh using RocksDB";
    homepage = "https://github.com/eclipse-zenoh/zenoh-backend-rocksdb";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
