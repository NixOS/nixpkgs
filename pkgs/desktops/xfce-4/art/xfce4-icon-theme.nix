{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "xfce4-icon-theme-4.4.3";
  
  src = fetchurl {
    url = "http://www.xfce.org/archive/src/art/xfce4-icon-theme/4.4/${name}.tar.bz2";
    sha1 = "0c0d0c45cd4a7f609310db8e9d17c1c4a131a6e7";
  };

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Icons for Xfce";
  };
}
