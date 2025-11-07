{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  gettext,
  gnome-settings-daemon,
  granite7,
  gtk4,
  glib,
  dbus,
  polkit,
  switchboard,
  wingpanel-indicator-power,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-power";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-power";
    tag = version;
    hash = "sha256-JfOLGDS2/Qa6RmEfiDBZfeT+dM4NN4N2NoXRNJ4Q+Es=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    dbus
    gnome-settings-daemon
    glib
    granite7
    gtk4
    libadwaita
    libgee
    polkit
    switchboard
    wingpanel-indicator-power # settings schema
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Power Plug";
    homepage = "https://github.com/elementary/settings-power";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
