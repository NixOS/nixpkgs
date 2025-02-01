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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-filesystem";
    tag = version;
    hash = "sha256-e7jVje4kI3/xRNk1s1z8WtpUIwPdMleyb0PvDz+vJ08=";
  };

  cargoHash = "sha256-PKwRGNZGv/vqogcotDudMF0IrzXMssPH2oDibAX/EEs=";

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
