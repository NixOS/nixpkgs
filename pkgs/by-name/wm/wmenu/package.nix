{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  meson,
  ninja,
  cairo,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "wmenu";
  version = "0.1.9";

  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "adnano";
    repo = "wmenu";
    rev = version;
    hash = "sha256-TF5BvgThvTOqxyfz5Zt/Z1cqjFJwvla+dgdyvz7Zhrg=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    cairo
    pango
    wayland
    libxkbcommon
    wayland-protocols
    scdoc
  ];

  meta = with lib; {
    description = "Efficient dynamic menu for Sway and wlroots based Wayland compositors";
    homepage = "https://codeberg.org/adnano/wmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eken ];
    mainProgram = "wmenu";
  };
}
