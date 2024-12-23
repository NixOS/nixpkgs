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
  granite7,
  gtk4,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-display";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-XeBctwLCeDM4AoHbqk6olc6rosBQDQ4uFm1Vv0stFVA=";
  };

  nativeBuildInputs = [
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

  meta = with lib; {
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/switchboard-plug-display";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
