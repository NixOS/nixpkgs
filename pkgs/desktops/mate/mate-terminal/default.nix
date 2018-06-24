{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-terminal-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0yfr857mpxy35zzdmicvd7mpwka8s1h0rqagfjqc2p1gv4a7ka97";
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
