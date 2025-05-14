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

stdenv.mkDerivation {
  pname = "wmenu";
  version = "0.1.9-unstable-2025-03-01";

  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "adnano";
    repo = "wmenu";
    rev = "fc69aa6e2bccca461a0bd0c10b448b64ccda1d42";
    hash = "sha256-ZssptllD6LPQUinKZime9A1dZJ3CkQvp+DUmk+iyaOA=";
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
