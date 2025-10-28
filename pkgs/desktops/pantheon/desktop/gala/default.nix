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
  version = "8.2.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    rev = version;
    hash = "sha256-uupFeQ73hr6ziLEtzgVJWASUxhspXJX54/U+3PLSCFY=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch

    # Fix gtk3 daemon menu location with x2 scaling
    # https://github.com/elementary/gala/pull/2493
    (fetchpatch {
      url = "https://github.com/elementary/gala/commit/33bc3ebe7f175c61845feaf2d06083f1e3b64ddc.patch";
      hash = "sha256-hjjiKcO5o/OABKD8vUsVyqtNKN4ffEOGZntLceLr2+k=";
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
