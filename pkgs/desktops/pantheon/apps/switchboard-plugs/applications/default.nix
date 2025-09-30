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
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-applications";
    tag = version;
    hash = "sha256-kmyAEm4MlyHfm2xC55qsFSk+aLEJMMCy7/Vi0dndaNU=";
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

  meta = with lib; {
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/settings-applications";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
