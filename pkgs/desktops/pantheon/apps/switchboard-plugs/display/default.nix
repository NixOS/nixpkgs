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
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-display";
    rev = version;
    sha256 = "sha256-/qWNs72x9Y2m+QOu5jLjtbIXjZhf6AGtLdpRpdED+AE=";
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
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/settings-display";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
