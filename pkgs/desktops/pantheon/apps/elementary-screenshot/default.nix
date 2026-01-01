{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
<<<<<<< HEAD
  wrapGAppsHook3,
  gdk-pixbuf,
  glib,
  granite,
  gtk3,
  libhandy,
=======
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  granite7,
  gtk4,
  libportal,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elementary-screenshot";
<<<<<<< HEAD
  # nixpkgs-update: no auto update
  # We disabled x-d-p-pantheon due to https://github.com/elementary/portals/issues/157
  # so hold back this before the issue is fixed since later versions enforce using portals.
  version = "8.0.0";
=======
  version = "8.0.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-z7FP+OZYF/9YLXYCQF/ElihKjKHVfeHc38RHdPb2aIE=";
=======
    hash = "sha256-nEJCyQs77zcUb9mc2dUBbZP3zWdPFHTOORROe3u6sSA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
<<<<<<< HEAD
    wrapGAppsHook3
=======
    wrapGAppsHook4
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    gdk-pixbuf
    glib
<<<<<<< HEAD
    granite
    gtk3
    libhandy
=======
    granite7
    gtk4
    libportal
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
=======
  meta = with lib; {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "io.elementary.screenshot";
  };
}
