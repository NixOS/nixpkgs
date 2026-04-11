{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  gdk-pixbuf,
  glib,
  granite,
  gtk3,
  libhandy,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elementary-screenshot";
  # nixpkgs-update: no auto update
  # We disabled x-d-p-pantheon due to https://github.com/elementary/portals/issues/157
  # so hold back this before the issue is fixed since later versions enforce using portals.
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
    hash = "sha256-z7FP+OZYF/9YLXYCQF/ElihKjKHVfeHc38RHdPb2aIE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    granite
    gtk3
    libhandy
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.screenshot";
  };
}
