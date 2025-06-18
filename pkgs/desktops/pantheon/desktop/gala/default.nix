{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  desktop-file-utils,
  gettext,
  libxml2,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook3,
  at-spi2-core,
  gnome-settings-daemon,
  gnome-desktop,
  granite,
  granite7,
  gtk3,
  gtk4,
  libcanberra,
  libgee,
  libhandy,
  mutter,
  sqlite,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "8.2.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    hash = "sha256-6M9IWwrCaJoi7b5e4ltdyZfdT7KkOgsollHNKhLPr9U=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch

    # WindowStateSaver: fix crash
    # https://github.com/elementary/gala/pull/2443
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/9defe95ef412f87eb14e0efd8b87f2fde5378a76.patch";
      hash = "sha256-P50ahXFlTLyHMT+WdHdLU2qNdMUnfXF+CjoJRchmyzw=";
    })
  ];

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
    wrapGAppsHook3
  ];

  buildInputs = [
    at-spi2-core
    gnome-settings-daemon
    gnome-desktop
    granite
    granite7
    gtk3
    gtk4 # gala-daemon
    libcanberra
    libgee
    libhandy
    mutter
    sqlite
    systemd
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "gala";
  };
}
