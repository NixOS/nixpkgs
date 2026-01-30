{
  stdenv,
  lib,
  fetchFromGitHub,
  desktop-file-utils,
  gettext,
  libxml2,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  at-spi2-core,
  gnome-settings-daemon,
  gnome-desktop,
  granite,
  granite7,
  gtk3,
  gtk4,
  libgee,
  libhandy,
  mutter,
  sqlite,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "gala";
  version = "8.4.0-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    # Contains crash fixes for mutter 48.
    # nixpkgs-update: no auto update
    rev = "8fb60a9c9b04245913733208df1c061d6c353a35";
    hash = "sha256-GBNrcUAC7UBdyrqoja81bD1oVHjLXWhnDz3gtjMbjII=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    at-spi2-core
    gnome-settings-daemon
    gnome-desktop
    granite
    granite7
    gtk3 # daemon-gtk3
    gtk4
    libgee
    libhandy
    mutter
    sqlite
    systemd
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "conf.set('PLUGINDIR', plugins_dir)" "conf.set('PLUGINDIR','/run/current-system/sw/lib/gala/plugins')"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "gala";
  };
}
