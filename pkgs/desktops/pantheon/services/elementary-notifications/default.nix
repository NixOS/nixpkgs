{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  glib,
  granite,
  libgee,
  libhandy,
  libcanberra-gtk3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-notifications";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = version;
    sha256 = "sha256-2+LV3O2V42gI+ysVoeO9KpLqmAj/Zk5F8LzO2RNZ1ZY=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra-gtk3
    libgee
    libhandy
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
