{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  glib,
  gtk4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pantheon-wayland";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-wayland";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-Wfulo/fXsb51ShT7E2wTg56TULAK1chB59L/ggGh2EY=";
=======
    hash = "sha256-UKGgz3G960dPmcDaFwLjDy55x+mDPdQQv2Ejs7BujLg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "dev"
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
  ];

  propagatedBuildInputs = [
    glib
    gtk4
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland integration library to the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-wayland";
    license = lib.licenses.lgpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
})
