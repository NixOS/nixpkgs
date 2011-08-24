{ stdenv, fetchurl, pkgconfig, intltool, libxfce4util, libxfcegui4, gtk }:

stdenv.mkDerivation rec {
  name = "mousepad-0.2.16";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/src/apps/mousepad/0.2/${name}.tar.bz2";
    sha1 = "4e63033e0a71578f3ec9a0d2e6a505efd0424ef9";
  };

  buildInputs = [ pkgconfig intltool libxfce4util libxfcegui4 gtk ];

  meta = {
    homepage = http://www.xfce.org/projects/mousepad/;
    description = "A simple text editor for Xfce";
    license = "GPLv2+";
  };
}
