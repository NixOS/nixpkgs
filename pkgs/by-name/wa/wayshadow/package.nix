{
  lib,
  stdenv,
  cairo,
  fetchFromGitHub,
  glib,
  gtk3,
  libappindicator,
  libinput,
  libxkbcommon,
  nix-update-script,
  pango,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayshadow";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "justanoobcoder";
    repo = "wayshadow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tJsCyohX74m9uZRkAFoRrCg6UGj9tEOEVbTfJigpHwQ=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    cairo
    glib
    gtk3
    libappindicator
    libinput
    libxkbcommon
    pango
    wayland
    wayland-protocols
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "WAYLAND_PROTOCOLS_DIR=${wayland-protocols}/share/wayland-protocols"
    "GIT_COMMIT=nix-build"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keystroke visualizer for Wayland compositors";
    homepage = "https://github.com/justanoobcoder/wayshadow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justanoobcoder ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshadow";
  };
})
