{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "gtk-xfce-engine-2.8.1";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/xfce/gtk-xfce-engine/2.8/${name}.tar.bz2";
    sha1 = "d7779f07cc76585be063bc25fa91e660e1fd9c97";
  };

  buildInputs =
    [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "GTK+ theme engine for Xfce";
    license = "GPLv2+";
  };
}
