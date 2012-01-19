{ stdenv, fetchurl, pkgconfig, glib, intltool }:

stdenv.mkDerivation rec {
  name = "libxfce4util-4.8.2";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/libxfce4util/4.8/${name}.tar.bz2";
    sha1 = "e7498c2e5fca2c89dfef89e0788f10eebbd020c3";
  };

  buildInputs = [ pkgconfig glib intltool ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic utility non-GUI functions for Xfce";
    license = "bsd";
  };
}
