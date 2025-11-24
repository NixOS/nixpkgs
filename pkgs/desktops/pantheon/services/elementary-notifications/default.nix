{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  glib,
  granite7,
  libadwaita,
  libcanberra,
  wayland-scanner,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    tag = version;
    hash = "sha256-V884jv7bleDMsuZDkodyeNBhStIoNPNxfT6mz1YjHXE=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    libcanberra
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    mainProgram = "io.elementary.notifications";
  };
}
