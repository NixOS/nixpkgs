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
  pname = "zenoh-backend-filesystem";
  version = "1.2.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-filesystem";
    tag = version;
    hash = "sha256-AQHJkUE2utFn4910+KGnf0wdXDMO6AmLVq1glp6k8Fc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-batUPE2/goNxmxNDW11EC3+ImrPv3UouuKHKSDDd4Gs=";

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
    platforms = lib.platforms.linux;
  };
}
