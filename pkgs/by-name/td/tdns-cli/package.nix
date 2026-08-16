{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "tdns-cli";
  version = "0.0.5-unstable-2026-02-23";

  src = fetchFromGitHub {
    owner = "rotty";
    repo = "tdns-cli";
    rev = "404ba636e031ff6101da633d3a572b1b075c0f37";
    hash = "sha256-e1JEQQI8226Ey5b3Z02xEAfy22eLPC10ANQVHAM7hDs=";
  };

  cargoHash = "sha256-G6YVZf2TxtIvEEeUtHWDITQfUayhEjS2QtXNSsvwg2M=";

  meta = {
    description = "DNS tool that aims to replace dig and nsupdate";
    homepage = "https://github.com/rotty/tdns-cli";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ astro ];
    mainProgram = "tdns";
  };
}
