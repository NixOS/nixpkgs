{ dbus-glib
, fetchFromGitHub
, gobject-introspection
, pkg-config
, lib
, stdenv
, wrapGAppsHook
, python3
, cairo
, gnome
, xapps
, keybinder3
, upower
, callPackage
, glib
, libffi
, gtk3
, readline
, spidermonkey_78
, meson
, sysprof
, dbus
, xvfb-run
, ninja
, makeWrapper
, which
, libxml2
, gtk4
}:

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cjs";
    rev = version;
    hash = "sha256-06sTk513qVMdznSHJzzB3XIPTcfjgxTB2o+ALqwPpHM=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    which # for locale detection
    libxml2 # for xml-stripblanks
  ];

  buildInputs = [
    gtk4
    gobject-introspection
    cairo
    readline
    spidermonkey_78
    dbus # for dbus-run-session
  ];

  checkInputs = [
    xvfb-run
  ];

  propagatedBuildInputs = [
    glib

    # bindings
    gnome.caribou
    keybinder3
    upower
    xapps
  ];

  mesonFlags = [
    "-Dprofiler=disabled"
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cjs";
    description = "JavaScript bindings for Cinnamon";

    longDescription = ''
      This module contains JavaScript bindings based on gobject-introspection.
    '';

    license = with licenses; [
      gpl2Plus
      lgpl2Plus
      mit
      mpl11
    ];

    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
