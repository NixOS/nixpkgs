{ stdenv, fetchurl_gnome, bison, pkgconfig, popt, libxml2, gtk, libtool
, intltool, libbonobo, GConf, libgnomecanvas, libgnome, libglade }:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurl_gnome {
    project = "libbonoboui";
    major = "2"; minor = "24"; patchlevel = "5";
    sha256 = "1kbgqh7bw0fdx4f1a1aqwpff7gp5mwhbaz60c6c98bc4djng5dgs";
  };

  buildNativeInputs = [ pkgconfig intltool ];
  buildInputs = [ bison popt gtk libxml2 GConf libglade libtool ];
  propagatedBuildInputs = [ libbonobo libgnomecanvas libgnome ];
}
