{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "gtk-xfce-engine-2.6.0";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/xfce/4.6.2/src/${name}.tar.bz2";
    sha1 = "a7be2f330833d150c5fb37f68a4c2138348b5446";
  };

  buildInputs =
    [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = "GPLv2+";
  };
}
