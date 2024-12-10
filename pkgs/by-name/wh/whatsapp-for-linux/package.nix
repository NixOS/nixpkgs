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
  webkitgtk_4_0,
  wrapGAppsHook3,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "whatsapp-for-linux";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "eneshecan";
    repo = "whatsapp-for-linux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hUIyn6BhAPoszBTHKa4qSj6IRa+8cUS0Gis/qjDDnyk=";
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
    webkitgtk_4_0
    xorg.libXdmcp
    xorg.libXtst
  ];

  meta = {
    homepage = "https://github.com/eneshecan/whatsapp-for-linux";
    description = "Whatsapp desktop messaging app";
    mainProgram = "whatsapp-for-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bartuka ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
