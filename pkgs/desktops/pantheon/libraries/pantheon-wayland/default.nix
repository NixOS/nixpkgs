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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-wayland";
    rev = finalAttrs.version;
    hash = "sha256-UKGgz3G960dPmcDaFwLjDy55x+mDPdQQv2Ejs7BujLg=";
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
    maintainers = lib.teams.pantheon.members;
    platforms = lib.platforms.linux;
  };
})
