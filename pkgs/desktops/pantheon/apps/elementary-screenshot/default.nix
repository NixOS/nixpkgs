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
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = version;
    hash = "sha256-/whMAypdjAN/0FYwkqk2VgsfL3eQ0h+ewoGspVmoIfk=";
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

  meta = {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.screenshot";
  };
}
