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
  version = "1.2.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-rocksdb";
    tag = version;
    hash = "sha256-pqeeH44/0+ok/DmH81JykvwOIC/pIUiLjzPzVEnekag=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dUQ9qGE+QphDH/vW1LXWzkJE2GSOU7Sn+xCENOvTsSc=";

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
