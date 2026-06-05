{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  accountsservice,
  glib,
  granite7,
  gsettings-desktop-schemas,
  gtk4,
  pantheon-wayland,
  systemd,
  libadwaita,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-pantheon";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "portals";
    tag = version;
    hash = "sha256-LmPLjOZVVHKMfYTEyOH2IkB/fw47pK0VqdWrckdBQ6w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    glib
    granite7
    gsettings-desktop-schemas
    gtk4
    pantheon-wayland
    systemd
    libadwaita
    libx11
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Backend implementation for xdg-desktop-portal for the Pantheon desktop environment";
    homepage = "https://github.com/elementary/portals";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
