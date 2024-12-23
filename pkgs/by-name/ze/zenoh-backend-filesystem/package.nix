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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-filesystem";
    tag = version;
    hash = "sha256-HZp0kR7vCXRg04aiRbefbTMprgOH3Chy7X2x8X9urTk=";
  };

  cargoHash = "sha256-HXxlgAszm2HbuKRhoWjluu/U9PMRHxs4/TRxEsl0Cgg=";

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
