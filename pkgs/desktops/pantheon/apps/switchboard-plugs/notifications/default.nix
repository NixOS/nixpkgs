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
  glib,
  granite7,
  gtk4,
  switchboard,
  elementary-notifications,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-notifications";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-notifications";
    tag = version;
    hash = "sha256-MYvSru/78jMhc1Rk8YuztajEdmRRssCFN7IMUHWzW78=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-notifications
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/settings-notifications";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
