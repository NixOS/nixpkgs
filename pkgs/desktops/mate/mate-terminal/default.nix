{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-terminal-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "053jdcjalywcq4fvqlb145sfp5hmnd6yyk9ckzvkh6fl3gyp54gc";
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
