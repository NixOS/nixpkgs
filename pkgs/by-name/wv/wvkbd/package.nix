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

stdenv.mkDerivation rec {
  pname = "wvkbd";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "jjsullivan5196";
    repo = "wvkbd";
    tag = "v${version}";
    hash = "sha256-RfZbPAaf8UB4scUZ9XSL12QZ4UkYMzXqfmNt9ObOgQ0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

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

  meta = with lib; {
    homepage = "https://github.com/jjsullivan5196/wvkbd";
    description = "On-screen keyboard for wlroots";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "wvkbd-mobintl";
  };
}
