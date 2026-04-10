{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "telemt";
  version = "3.3.28";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = version;
    hash = "sha256-u5/HiFIinKvpTItUsBnLhsGhAXN3V2qeeUGmvcFlJI8=";
  };

  cargoHash = "sha256-FGXdWhjqlb0urBtSbU1afebgy3a/CLGB+aHv3ccIiy8=";

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram on Rust + Tokio";
    homepage = "https://github.com/telemt/telemt";
    maintainers = with lib.maintainers; [ r4v3n6101 ];
  };
}
