{ stdenv
, lib
, fetchFromGitHub
, substituteAll
, cairo
, cinnamon-desktop
, dbus
, desktop-file-utils
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
, wrapGAppsHook
, xorgserver
}:

stdenv.mkDerivation rec {
  pname = "muffin";
  version = "5.4.6";

  outputs = [ "out" "dev" "man" ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      zenity = gnome.zenity;
    })
  ];

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-xTpL+o7gFvu8VNbCb8c0Y0Z8ncqb9y2qTiXP3rHAz+M=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    mesa # needed for gbm
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
    xorgserver # for cvt command
  ];

  buildInputs = [
    cairo
    cinnamon-desktop
    dbus
    glib
    gobject-introspection
    gtk3
    libcanberra
    libdrm
    libgnomekbd
    libgudev
    libinput
    libstartup_notification
    libwacom
    libXdamage
    libxkbcommon
    pipewire
    udev
  ];

  propagatedBuildInputs = [
    # required for pkg-config to detect muffin-clutter
    json-glib
    libXtst
    graphene
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
