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
  gst_all_1,
  gtk4,
  libadwaita,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "elementary-videos";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = version;
    hash = "sha256-lvIsLjsb4HqwXDsH2krBlxmy7kJdadpjDcw+svaWV+Q=";
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
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    # https://github.com/elementary/videos/issues/356
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-rs # GTK 4 Sink
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.elementary.videos";
  };
}
