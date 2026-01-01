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
<<<<<<< HEAD
  version = "8.0.2";
=======
  version = "8.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-agent-polkit";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-tuugtrnamY9QMlF/ju5+4gwcEESFqH4jDH/kz790v5Y=";
=======
    hash = "sha256-qqeB8SLuES/KoK7ycQ2J1YBA07HITovdnO8kSsrVcfs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-agent-polkit";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-agent-polkit";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
