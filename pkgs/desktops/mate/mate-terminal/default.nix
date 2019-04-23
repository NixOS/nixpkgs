{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, gnome3, gtk3, vte, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-terminal-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0fqyi0az4ax1gyk5gymd7ssq2crdcd7slmqljc1b1pa283ql7p3q";
  };

  buildInputs = [
     glib
     itstool
     libxml2

     mate.mate-desktop

     vte
     gtk3
     gnome3.dconf
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  meta = with stdenv.lib; {
    description = "The MATE Terminal Emulator";
    homepage = https://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
