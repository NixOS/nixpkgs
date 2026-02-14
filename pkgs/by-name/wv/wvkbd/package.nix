{
  stdenv,
  lib,
  fetchFromGitHub,
  wayland-scanner,
  wayland,
  pango,
  glib,
  harfbuzz,
  cairo,
  pkg-config,
  libxkbcommon,
  scdoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wvkbd";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "jjsullivan5196";
    repo = "wvkbd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aQA5xY3jDSLsANxNX3mGu+LElyOn6lPjxEaqS1v2JaI=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    cairo
    glib
    harfbuzz
    libxkbcommon
    pango
    wayland
  ];
  installFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/jjsullivan5196/wvkbd";
    description = "On-screen keyboard for wlroots";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    mainProgram = "wvkbd-mobintl";
    maintainers = with lib.maintainers; [ colinsane ];
  };
})
