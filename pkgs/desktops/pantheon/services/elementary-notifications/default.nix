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
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    tag = version;
    hash = "sha256-qod76RSsCO9NvjnYTLRW6P1UyR1K6Uu9fEjU2WgHUWk=";
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

<<<<<<< HEAD
  meta = {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = licenses.gpl3Plus;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.elementary.notifications";
  };
}
