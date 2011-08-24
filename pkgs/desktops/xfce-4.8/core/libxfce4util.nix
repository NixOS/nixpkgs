{ stdenv, fetchurl, pkgconfig, glib, intltool }:

stdenv.mkDerivation rec {
  name = "libxfce4util-4.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/libxfce4util/4.8/${name}.tar.bz2";
    sha1 = "4d26aea58413603e2c163ff0374a6e32fc47bc4c";
  };

  buildInputs = [ pkgconfig glib intltool ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic utility non-GUI functions for Xfce";
    license = "bsd";
  };
}
