{ autoconf-archive
, autoreconfHook
, dbus-glib
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
, networkmanagerapplet
}:

let

  # https://github.com/linuxmint/cjs/issues/80
  spidermonkey_52 = callPackage ./spidermonkey_52.nix {};

in

stdenv.mkDerivation rec {
  pname = "cjs";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0q5h2pbwysc6hwq5js3lwi6zn7i5qjjy070ynfhfn3z69lw5iz2d";
  };

  propagatedBuildInputs = [
    glib

    # bindings
    gnome3.caribou
    keybinder3
    upower
    xapps
    networkmanagerapplet
  ];

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    wrapGAppsHook
    pkgconfig
  ];

  buildInputs = [
    # from .pc
    gobject-introspection
    libffi
    spidermonkey_52 # mozjs-52
    cairo # +cairo-gobject
    gtk3

    # other

    dbus-glib
    readline
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
    maintainers = [ maintainers.mkg20001 ];
  };
}
