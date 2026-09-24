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
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = finalAttrs.version;
    hash = "sha256-IzrwFiLJfvFKHdYaDmaYYwdBUlQed9WEy/7OBvlAUTQ=";
  };

  cargoHash = "sha256-tq2Hc5CAp5Cp6AYS/NGb0HEtvm+lH8qak+M8toksDF4=";

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
