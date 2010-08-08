{ stdenv, fetchurl, pkgconfig, glib, intltool }:

stdenv.mkDerivation rec {
  name = "libxfce4util-4.6.2";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce-4.6.2/src/${name}.tar.bz2";
    sha256 = "10wcw7r8cjb0farffic037pcjr5bwrjrm8s3jrcb7c0b038pwbmf";
  };

  buildInputs = [ pkgconfig glib intltool ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Basic utility non-GUI functions for Xfce";
    license = "GPLv2";
  };
}
