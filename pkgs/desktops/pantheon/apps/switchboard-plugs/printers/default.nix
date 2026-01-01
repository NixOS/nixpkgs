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

<<<<<<< HEAD
  meta = {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/settings-printers";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/settings-printers";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
