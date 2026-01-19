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
  libcanberra,
  libgee,
  glib,
  granite7,
  gtk4,
  pulseaudio,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sound";
    tag = version;
    hash = "sha256-eemNFGTh/QQJst04t+fzyDkowpAVRQpMS8EFUiLIMok=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libcanberra
    libgee
    pulseaudio
    switchboard
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/settings-sound";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
