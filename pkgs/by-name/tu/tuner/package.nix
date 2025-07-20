{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  itstool,
  wrapGAppsHook3,
  desktop-file-utils,
  libsoup_3,
  json-glib,
  libgee,
  gtk3,
  pantheon,
  gst_all_1,
}:

stdenv.mkDerivation rec {
  pname = "tuner";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "louis77";
    repo = "tuner";
    tag = "v${version}";
    hash = "sha256-i6I5NSwiS8FJuZaHbrXvUcumo9RZvEVPcfKOkHUXiLo=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    glib
    itstool
    wrapGAppsHook3
    desktop-file-utils
  ];

  buildInputs = [
    libsoup_3
    json-glib
    libgee
    glib
    gtk3
    pantheon.granite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
  ];

  meta = {
    homepage = "https://github.com/louis77/tuner";
    description = "App to discover and play internet radio stations";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "com.github.louis77.tuner";
    maintainers = with lib.maintainers; [
      abbe
      aleksana
    ];
  };
}
