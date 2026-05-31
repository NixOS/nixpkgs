{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  __structuredAttrs = true;

  pname = "tetro-tui";
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "Strophox";
    repo = "tetro-tui";
    rev = "v${version}";
    hash = "sha256-9UHP3mo7sEjVPtBdLgbJpW3RlyXA8zAbY20CgBVdptg=";
  };

  cargoHash = "sha256-fBbHwCnlUuas+g1dFIRmOZM+hD32tp/++k1KNEFzphY=";

  meta = with lib; {
    description = "Tetro TUI is a terminal-based but modern tetromino-stacking game that is customizable and cross-platform.";
    homepage = "https://github.com/Strophox/tetro-tui";
    license = licenses.mit;
    mainProgram = "tetro-tui";
    platforms = platforms.linux;
  };
}
