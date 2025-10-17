{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  elementary-bluetooth-daemon,
  libgee,
  gettext,
  granite7,
  gtk4,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-sharing";
    rev = version;
    hash = "sha256-XTgUHgvBSzZeuUup0gT6sbhyT4FGGG7o+qbPmfeRVQE=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-bluetooth-daemon
    granite7
    gtk4
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Sharing Plug";
    homepage = "https://github.com/elementary/switchboard-plug-sharing";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
