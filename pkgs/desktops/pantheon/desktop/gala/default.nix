{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, gettext
, libxml2
, gtk3
, gtk4
, granite
, granite7
, libgee
, libhandy
, libcanberra-gtk3
, gnome-desktop
, mesa
, mutter
, gnome-settings-daemon
, wayland-scanner
, wrapGAppsHook3
, sqlite
, systemd
, pantheon-agent-polkit
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-DxrZoEwTZZ7Tvu8Q37nxU5cDA2kcMssNJH9vkDtnJvc=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch
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
    gnome-settings-daemon
    gnome-desktop
    granite
    granite7
    gtk3
    gtk4 # gala-daemon
    libcanberra-gtk3
    libgee
    libhandy
    mesa # for libEGL
    mutter
    sqlite
    systemd
  ];

  VALAFLAGS = "-g";
  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "gala";
  };
}
