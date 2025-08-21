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
  gst_all_1,
  gtk4,
  libadwaita,
  libcanberra,
  libgee,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elementary-camera";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "camera";
    rev = version;
    sha256 = "sha256-jJJhCFDo5Iw6zV6aE8JgG/sMFpUfra2j2zQ8+GjyQrk=";
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
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-rs # GTK 4 sink
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libcanberra
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Camera app designed for elementary OS";
    homepage = "https://github.com/elementary/camera";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.camera";
  };
}
