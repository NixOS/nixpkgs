{
  lib,
  stdenv,
  desktop-file-utils,
  nix-update-script,
  fetchFromGitHub,
  flatpak,
  gettext,
  glib,
  granite7,
  gtk4,
  meson,
  ninja,
  pkg-config,
  vala,
  libxml2,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "sideload";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sideload";
    tag = version;
    hash = "sha256-mFaMKY4SdnSdRsHy5vIbJFdMx2FGxYCWmSAWkb99yUI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    granite7
    gtk4
    libxml2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/elementary/sideload";
    description = "Flatpak installer, designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    homepage = "https://github.com/elementary/sideload";
    description = "Flatpak installer, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.elementary.sideload";
  };
}
