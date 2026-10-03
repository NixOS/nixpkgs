{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wastebin";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = finalAttrs.version;
    hash = "sha256-ybKa6ZkQek9S0Zjz/lRODzjWvzTTu+PtfMrnYu+Nzrs=";
  };

  cargoHash = "sha256-hdu+t3xdS7KYcos6N1EkygCoAdaUOowldb0NGEOPtSQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.tests = {
    inherit (nixosTests) wastebin;
  };

  meta = {
    description = "Pastebin service";
    homepage = "https://github.com/matze/wastebin";
    changelog = "https://github.com/matze/wastebin/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pinpox
      matthiasbeyer
    ];
    mainProgram = "wastebin";
  };
})
