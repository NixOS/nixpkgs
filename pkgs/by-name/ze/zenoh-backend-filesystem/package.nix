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
  pname = "zenoh-backend-filesystem";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-filesystem";
    tag = version;
    hash = "sha256-V35nqrTUQb5Emn6kgGubvVkTHYQHDz82p3S7pk0Aagg=";
  };

  cargoHash = "sha256-qpubYs7JEdL1iSYrMQ2HXPXrkCmFLjHyC0+MhiolEFk=";

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
