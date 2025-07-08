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
  version = "0.17";

  src = fetchFromGitHub {
    owner = "jjsullivan5196";
    repo = "wvkbd";
    tag = "v${version}";
    hash = "sha256-Vjbj3rxTe60Q+6IcX43WCBHMyPFECjc8w9D6qed0w0I=";
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
