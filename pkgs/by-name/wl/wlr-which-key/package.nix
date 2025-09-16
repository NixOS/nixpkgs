{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cairo,
  glib,
  libxkbcommon,
  pango,
}:

rustPlatform.buildRustPackage rec {
  pname = "wlr-which-key";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "wlr-which-key";
    rev = "v${version}";
    hash = "sha256-2dVTN5aaXeGBUKhsuUyDfELyL4AcKoaPXD0gN7ydL/Y=";
  };

  cargoHash = "sha256-v+4/lD00rjJvrQ2NQqFusZc0zQbM9mBG5T9bNioNGKQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cairo
    glib
    libxkbcommon
    pango
  ];

  meta = with lib; {
    description = "Keymap manager for wlroots-based compositors";
    homepage = "https://github.com/MaxVerevkin/wlr-which-key";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ xlambein ];
    platforms = platforms.linux;
    mainProgram = "wlr-which-key";
  };
}
