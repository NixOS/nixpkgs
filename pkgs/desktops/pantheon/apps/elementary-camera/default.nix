{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  glib,
  granite7,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-rs,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  gtk4,
  libadwaita,
  libcanberra,
  libgee,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elementary-camera";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "camera";
    rev = version;
    hash = "sha256-0GwdCckL3+mxCScH5msxwXSbjPqKrn1i6RfP1R72muo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gst-plugins-bad
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-rs # GTK 4 sink
    gst-plugins-ugly
    gstreamer
    gtk4
    libadwaita
    libcanberra
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Camera app designed for elementary OS";
    homepage = "https://github.com/elementary/camera";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.camera";
  };
}
