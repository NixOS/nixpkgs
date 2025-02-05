{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  rocksdb,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-rocksdb";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-rocksdb";
    tag = version;
    hash = "sha256-YZf3riWMzcyguZbfGheIbAlCijML7zPG+XAJso6ku9E=";
  };

  cargoHash = "sha256-bzUY9iARGAXErYOH0S6q6JlfdFQJDDg5q1D2miMrzNE=";

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
    description = "Backend and Storages for zenoh using RocksDB";
    homepage = "https://github.com/eclipse-zenoh/zenoh-backend-rocksdb";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
}
