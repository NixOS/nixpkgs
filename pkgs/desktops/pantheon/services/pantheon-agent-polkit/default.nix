{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  libadwaita,
  libgee,
  granite7,
  pantheon-wayland,
  polkit,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-polkit";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-agent-polkit";
    rev = version;
    hash = "sha256-qqeB8SLuES/KoK7ycQ2J1YBA07HITovdnO8kSsrVcfs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    pantheon-wayland
    polkit
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-agent-polkit";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
