{stdenv, fetchurl, pkgconfig, glib, intltool, gnome_vfs, libbonobo, ORBit2}:

stdenv.mkDerivation {
  name = "gnome-vfs-monikers-2.15.3";
  src = fetchurl {
    url = mirror://gnome/sources/gnome-vfs-monikers/2.15/gnome-vfs-monikers-2.15.3.tar.bz2;
    sha256 = "0gpgk5vwhgqfhrd8pf1314kh7sv3jfqll2xbdbrs5s5sxy3v7b15";
  };
  buildInputs = [ pkgconfig glib intltool gnome_vfs libbonobo ];
}
