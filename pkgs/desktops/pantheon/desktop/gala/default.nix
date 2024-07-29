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
  version = "7.1.3-unstable-2024-07-28";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = "72ee7e1d751370779675a86258b5a764b363142a"; #1990
    sha256 = "sha256-NnRc4DD1CdVkhJQRBcqvJd3MJKv+gfzYUuBVcHEG2W8=";
  };

  patches = [
    # We look for plugins in `/run/current-system/sw/lib/` because
    # there are multiple plugin providers (e.g. gala and wingpanel).
    ./plugins-dir.patch
  ];

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

  # Draft PR! Temporarily adding this for debugging.
  VALAFLAGS = "-g";
  separateDebugInfo = true;

  postPatch = ''
    substituteInPlace data/io.elementary.desktop.wm.shell \
      --replace-fail "/usr/libexec" "${pantheon-agent-polkit}/libexec"
  '';

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
