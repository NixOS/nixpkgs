{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  glib,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  libgudev,
  libwacom,
  switchboard,
  libxi,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-wacom";
    tag = version;
    hash = "sha256-LA3sOY5ENaSO99AMLAqPryEfyPsKwcatzZoGOhbvCJY=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    libgee
    libgudev
    libwacom
    switchboard
    libx11
    libxi
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Wacom Plug";
    homepage = "https://github.com/elementary/settings-wacom";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
