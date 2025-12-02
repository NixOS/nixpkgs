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
  granite7,
  gtk4,
  cups,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-printers";
    tag = version;
    hash = "sha256-oqdmARZamTbMwpKKmyVZflYLCd0Qf5iE5lHSMfdPGA8=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
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
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/settings-printers";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };

}
