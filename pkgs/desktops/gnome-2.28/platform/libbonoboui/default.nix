{ stdenv, fetchurl, bison, pkgconfig, popt, libxml2, gtk
, intltool, libbonobo, GConf, libgnomecanvas, libgnome, libglade }:

stdenv.mkDerivation {
  name = "libbonoboui-2.24.2";
  
  src = fetchurl {
    url = mirror://gnome/sources/libbonoboui/2.24/libbonoboui-2.24.2.tar.bz2;
    sha256 = "005ypnzb3mfsb0k0aa3h77vwc4ifjq6r4d11msqllvx7avfgkg5f";
  };
  
  buildInputs = [ bison pkgconfig popt gtk libxml2 intltool GConf libglade ];
  propagatedBuildInputs = [ libbonobo libgnomecanvas libgnome ];
}
