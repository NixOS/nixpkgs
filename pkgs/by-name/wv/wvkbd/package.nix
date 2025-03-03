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
  version = "0.16";

  src = fetchFromGitHub {
    owner = "jjsullivan5196";
    repo = "wvkbd";
    tag = "v${version}";
    hash = "sha256-8KRJsx0Zv1VH/lR/QEE9kkzEY2qWihHaog2YxgNd4Rs=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    cairo
    glib
    harfbuzz
    libxkbcommon
    pango
    wayland
    scdoc
  ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/jjsullivan5196/wvkbd";
    description = "On-screen keyboard for wlroots";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "wvkbd-mobintl";
  };
}
