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
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-GLeQxdrrjz4MurN8Ia5Q68y6gHuyxiMVNneft1AXKvs=";
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
    homepage = "https://github.com/elementary/switchboard-plug-sound";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.pantheon.members;
  };
}
