{ stdenv, fetchurl, pkgconfig, intltool, gtk }:

stdenv.mkDerivation rec {
  name = "xfwm4-themes-4.10.0";
  
  src = fetchurl {
    url = "http://archive.xfce.org/src/art/xfwm4-themes/4.10/${name}.tar.bz2";
    sha256 = "0xfmdykav4rf6gdxbd6fhmrfrvbdc1yjihz7r7lba0wp1vqda51j";
  };

  buildInputs = [ pkgconfig intltool gtk ];

  meta = {
    homepage = http://www.xfce.org/;
    description = "Themes for Xfce";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
