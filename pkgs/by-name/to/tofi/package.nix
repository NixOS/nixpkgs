{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ninja,
  meson,
  scdoc,
  wayland-protocols,
  wayland-scanner,
  freetype,
  harfbuzz,
  cairo,
  pango,
  wayland,
  libxkbcommon,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "tofi";
  version = "0.9.1-unstable-2024-12-30";

  src = fetchFromGitHub {
    owner = "philj56";
    repo = "tofi";
    rev = "1eb6137572ab6c257ab6ab851d5d742167c18120";
    hash = "sha256-OD56rwDrXgb5pg85sT5v+zl9A1/sfn77PBSG4gT76bE=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-protocols
    wayland-scanner
  ];
  buildInputs = [
    freetype
    harfbuzz
    cairo
    pango
    wayland
    libxkbcommon
  ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "Tiny dynamic menu for Wayland";
    homepage = "https://github.com/philj56/tofi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbergroth ];
    platforms = lib.platforms.linux;
    mainProgram = "tofi";
  };
}
