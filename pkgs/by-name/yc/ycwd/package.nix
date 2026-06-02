{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "ycwd";
  version = "0-unstable-2025-07-09";

  src = fetchFromGitHub {
    owner = "blinry";
    repo = "ycwd";
    rev = "5676dafe3700ac76e071424a47407186a08d1c77";
    hash = "sha256-HFRS+cNHKloASKXB/Tlrvpsmbg78V4lrNx9WehyzMxE=";
  };

  cargoHash = "sha256-HTlIcrn/QtyY2vLxfeC2RXD1mniWYE7m/rV1QBI4PZc=";

  meta = {
    description = "Helps replace xcwd on Wayland compositors";
    homepage = "https://github.com/blinry/ycwd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lenny ];
    mainProgram = "ycwd";
  };
}
