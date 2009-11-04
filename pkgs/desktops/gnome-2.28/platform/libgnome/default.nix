{ stdenv, fetchurl, pkgconfig, glib, popt, zlib
, intltool, esound, libbonobo, GConf, gnome_vfs, ORBit2}:

stdenv.mkDerivation {
  name = "libgnome-2.28.0";
  
  src = fetchurl {
    url = mirror://gnome/sources/libgnome/2.28/libgnome-2.28.0.tar.bz2;
    sha256 = "03hc1m88swxxw4cq491kz7495ksv762imamzbbvhci41bc40anwv";
  };
  
  buildInputs = [ pkgconfig popt zlib intltool GConf gnome_vfs ];
  propagatedBuildInputs = [ glib libbonobo esound ];
}
