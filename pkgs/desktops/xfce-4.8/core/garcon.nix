{ stdenv, fetchurl, pkgconfig, intltool, glib, libxfce4util }:

stdenv.mkDerivation rec {
  name = "garcon-0.1.9";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/garcon/0.1/${name}.tar.bz2";
    sha1 = "2eeab19bc10747a40b44afd4598a2f555eb69952";
  };

  buildInputs = [ pkgconfig intltool glib libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Xfce menu support library";
    license = "GPLv2+";
  };
}
