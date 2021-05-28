{ dbus-glib
, fetchFromGitHub
, gobject-introspection
, pkgconfig
, stdenv
, wrapGAppsHook
, python3
, cairo
, gnome3
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
, xvfb_run
, ninja
, makeWrapper
, which
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "4.6.0-gjs-1.66.0";

  src = fetchFromGitHub {
    owner = "leigh123linux";
    repo = pname;
    rev = "gjs-1.66.0";
    sha256 = "1pccz7h8mwljziflhn04gmfnbl99pvcj1byz1c6zn947v5gqskj1";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson # ADDING cmake breaks the build, ignore meson warning
    ninja
    pkgconfig
    makeWrapper
    which # for locale detection
    libxml2 # for xml-stripblanks
  ];

  buildInputs = [
    gobject-introspection
    cairo
    readline
    spidermonkey_78
    dbus # for dbus-run-session
  ];

  checkInputs = [
    xvfb_run
  ];

  propagatedBuildInputs = [
    glib

    # bindings
    gnome3.caribou
    keybinder3
    upower
    xapps
  ];

  mesonFlags = [
    "-Dprofiler=disabled"
  ];

  meta = with stdenv.lib; {
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
