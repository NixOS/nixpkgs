{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-terminal-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "03366hs7mxazn6m6y53ppkb1din4jywljg0lx8zw101qg6car0az";
  };

  buildInputs = [
     glib
     itstool
     libxml2

     mate.mate-desktop

     gnome3.vte
     gnome3.gtk
     gnome3.dconf
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  meta = with stdenv.lib; {
    description = "The MATE Terminal Emulator";
    homepage = http://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
