{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  granite7,
  gtk4,
  libportal,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elementary-screenshot";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
    hash = "sha256-nEJCyQs77zcUb9mc2dUBbZP3zWdPFHTOORROe3u6sSA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    granite7
    gtk4
    libportal
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.screenshot";
  };
}
