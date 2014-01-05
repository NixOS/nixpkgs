{ stdenv, fetchurl, pkgconfig, python, glib, zlib, libpng }:

stdenv.mkDerivation rec {
  name = "lensfun-0.2.7";

  src = fetchurl {
    url = "http://download.berlios.de/lensfun/${name}.tar.bz2";
    sha256 = "0xv4h219zn0ldhhjnjc1q2bgpbfqzpd4b31gf9yyrwbapm3hgprx";
  };

  patchPhase = "sed -e 's@/usr/bin/python@${python}/bin/python@' -i configure";

  buildInputs = [ pkgconfig glib zlib libpng ];

  configureFlags = "-v";

  meta = with stdenv.lib; {
    platforms = platforms.all;
    maintainers = [ maintainers.urkud ];
    license = "LGPL3";
    description = "An opensource database of photographic lenses and their characteristics";
  };
}
