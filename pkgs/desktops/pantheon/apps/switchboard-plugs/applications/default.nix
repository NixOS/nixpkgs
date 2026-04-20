{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  granite7,
  gtk4,
  switchboard,
  flatpak,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-applications";
    tag = version;
    hash = "sha256-2sa6D+vOQidFwBBiqFioOocN//3A3RLKX7w0U62K4oI=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    flatpak
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
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/settings-applications";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
