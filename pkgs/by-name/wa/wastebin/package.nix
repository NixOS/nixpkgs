{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  zstd,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "wastebin";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "matze";
    repo = "wastebin";
    rev = version;
    hash = "sha256-emhPa4VuXOjTZ6AU/4S8acjjz68byBg4x4MW0M5hvD4=";
  };

  cargoHash = "sha256-Ub6BQhrLkIoOM9XFVIfm6mI4pP1Rloo3DnZXB8C4CjE=";

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

  meta = with lib; {
    description = "Wastebin is a pastebin";
    homepage = "https://github.com/matze/wastebin";
    changelog = "https://github.com/matze/wastebin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      pinpox
      matthiasbeyer
    ];
    mainProgram = "wastebin";
  };
}
