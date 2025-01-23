{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  zstd,
  rocksdb_8_11,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-rocksdb";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-rocksdb";
    tag = version;
    hash = "sha256-+dA/4VA1oHhTiMcSXful2Z1B+IYykPMC/2p0mjEbako=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JYBhaPROsk8+df0tIO2i7hp0Ms1DEGZ2ykL7Fiyddd4=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    bzip2
    zstd
  ];

  env = {
    ROCKSDB_INCLUDE_DIR = "${rocksdb_8_11}/include";
    ROCKSDB_LIB_DIR = "${rocksdb_8_11}/lib";
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
