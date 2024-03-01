{ stdenv
, lib
, fetchFromGitHub
, substituteAll
, cairo
, cinnamon-desktop
, dbus
, desktop-file-utils
, egl-wayland
, glib
, gnome
, gobject-introspection
, graphene
, gtk3
, json-glib
, libcanberra
, libdrm
, libgnomekbd
, libgudev
, libinput
, libstartup_notification
, libwacom
, libxcvt
, libXdamage
, libxkbcommon
, libXtst
, mesa
, meson
, ninja
, pipewire
, pkg-config
, python3
, udev
, wayland
, wayland-protocols
, wrapGAppsHook
, xorgserver
, xwayland
}:

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "6.0.1";

  outputs = [ "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-yd23naaPIa6xrdf7ipOvVZKqkr7/CMxNqDZ3CQ2QH+Y=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      zenity = gnome.zenity;
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    mesa # needed for gbm
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
    xorgserver # for cvt command
    gobject-introspection
  ];

  buildInputs = [
    cairo
    cinnamon-desktop
    dbus
    egl-wayland
    glib
    gtk3
    libcanberra
    libdrm
    libgnomekbd
    libgudev
    libinput
    libstartup_notification
    libwacom
    libxcvt
    libXdamage
    libxkbcommon
    pipewire
    udev
    wayland
    wayland-protocols
    xwayland
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect muffin-clutter
    json-glib
    libXtst
    graphene
  ];

  mesonFlags = [
    # Based on Mint's debian/rules.
    "-Degl_device=true"
    "-Dwayland_eglstream=true"
    "-Dxwayland_path=${lib.getExe xwayland}"
  ];

  postPatch = ''
    patchShebangs src/backends/native/gen-default-modes.py
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/muffin";
    description = "The window management library for the Cinnamon desktop (libmuffin) and its sample WM binary (muffin)";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
