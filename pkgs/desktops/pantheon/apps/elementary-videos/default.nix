{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  gdk-pixbuf,
  granite7,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-rs,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gst-libav,
  gtk4,
  libadwaita,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "elementary-videos";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = version;
    hash = "sha256-a6KV3F/18CkAc810WhZUvu/5wLi3bhi/Y8MBSwah5eU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    granite7
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    # https://github.com/elementary/videos/issues/356
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-rs # GTK 4 Sink
    gst-plugins-ugly
    gstreamer
    gtk4
    libadwaita
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.videos";
  };
}
