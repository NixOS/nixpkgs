{ stdenv, fetchurl, pkgconfig, glib, popt
, intltool, esound, audiofile, libbonobo, GConf, gnome_vfs, ORBit2}:

stdenv.mkDerivation {
  name = "libgnome-2.28.0";
  src = fetchurl {
    url = mirror:/gnome/sources/libgnome/2.28/libgnome-2.28.0.tar.bz2;
    sha256 = "03hc1m88swxxw4cq491kz7495ksv762imamzbbvhci41bc40anwv"
  };
  buildInputs = [ pkgconfig glib popt intltool esound audiofile libbonobo GConf gnome_vfs ];
  CPPFLAGS = "-I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${ORBit2}/include/orbit-2.0 -I${libbonobo}/include/libbonobo-2.0 -I${libbonobo}/include/bonobo-activation-2.0 -I${GConf}/include/gconf/2 -I${gnome_vfs}/include/gnome-vfs-2.0";
  LIBS = "-lesd -lgconf-2 -lbonobo-activation -lbonobo-2 -lgnomevfs-2";
}
