{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "telemt";
  version = "3.3.28";

  src = fetchFromGitHub {
    owner = "telemt";
    repo = "telemt";
    tag = finalAttrs.version;
    hash = "sha256-u5/HiFIinKvpTItUsBnLhsGhAXN3V2qeeUGmvcFlJI8=";
  };

  cargoHash = "sha256-FGXdWhjqlb0urBtSbU1afebgy3a/CLGB+aHv3ccIiy8=";

  meta = {
    mainProgram = "telemt";
    description = "MTProxy for Telegram";
    homepage = "https://github.com/telemt/telemt";
    license = {
      shortName = "telemt-license";
      fullName = "TELEMT Public License 3";
      url = "https://github.com/telemt/telemt/blob/main/LICENSE";
      free = false;
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      c0bectb
      r4v3n6101
    ];
  };
})
