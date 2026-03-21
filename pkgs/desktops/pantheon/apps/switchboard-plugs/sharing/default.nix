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
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sharing";
    tag = version;
    hash = "sha256-TNLnSFvjJFUfDkhYSKgqgpmpZggIw3LcBqmkXIzZ3nk=";
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

  meta = {
    description = "Switchboard Sharing Plug";
    homepage = "https://github.com/elementary/settings-sharing";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
