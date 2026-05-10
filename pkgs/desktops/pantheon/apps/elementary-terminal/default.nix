{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  gtk4,
  granite7,
  libadwaita,
  vte-gtk4,
  libgee,
  pcre2,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "elementary-terminal";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "terminal";
    tag = version;
    hash = "sha256-IzLaM9FPMRGJKvlXktyrhDYSyP4LJ8yFW8/FmsmZjU4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
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
    pcre2
    vte-gtk4
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal emulator designed for elementary OS";
    longDescription = ''
      A super lightweight, beautiful, and simple terminal. Comes with sane defaults, browser-class tabs, sudo paste protection,
      smart copy/paste, and little to no configuration.
    '';
    homepage = "https://github.com/elementary/terminal";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.terminal";
  };
}
