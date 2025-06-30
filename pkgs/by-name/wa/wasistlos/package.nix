{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  glib-networking,
  gst_all_1,
  gtkmm3,
  libayatana-appindicator,
  libcanberra,
  libepoxy,
  libpsl,
  libdatrie,
  libdeflate,
  libselinux,
  libsepol,
  libsysprof-capture,
  libthai,
  libxkbcommon,
  sqlite,
  pcre,
  pcre2,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wasistlos";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "xeco23";
    repo = "WasIstLos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h07Qf34unwtyc1VDtCCkukgBDJIvYNgESwAylbsjVsQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtkmm3
    libayatana-appindicator
    libcanberra
    libdatrie
    libdeflate
    libepoxy
    libpsl
    libselinux
    libsepol
    libsysprof-capture
    libthai
    libxkbcommon
    pcre
    pcre2
    sqlite
    webkitgtk_4_1
    xorg.libXdmcp
    xorg.libXtst
  ];

  meta = {
    homepage = "https://github.com/xeco23/WasIstLos";
    description = "Unofficial WhatsApp desktop application";
    mainProgram = "wasistlos";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bartuka ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
