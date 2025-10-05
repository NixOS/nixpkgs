{
  lib,
  stdenv,
  desktop-file-utils,
  fetchFromGitHub,
  gobject-introspection,
  gtk4,
  libadwaita,
  libsecret,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pantheon,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "taxi";
  version = "2.0.2-unstable-2024-12-26";

  # Temporarily disable nixpkgs-update before we have a tagged release.
  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "ellie-commons";
    repo = "taxi";
    rev = "b1c81490641f102005d9451a33d21610c0637e22";
    sha256 = "sha256-boPwRSHzFpbrzRoSmNWf/fgi3cJDEt9qjZHWQWutL+o=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libsecret
    libsoup_3
    pantheon.granite7
  ];
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/ellie-commons/taxi";
    description = "FTP Client that drives you anywhere";
    license = licenses.lgpl3Plus;
    teams = [ teams.pantheon ];
    platforms = platforms.linux;
    mainProgram = "io.github.ellie_commons.taxi";
  };
}
