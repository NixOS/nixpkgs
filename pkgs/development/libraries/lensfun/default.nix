{ stdenv, fetchurl, pkgconfig, python, glib, zlib, libpng, gnumake3 }:

stdenv.mkDerivation rec {
  name = "lensfun-0.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/lensfun/${name}.tar.bz2";
    sha256 = "0j0smagnksdm9gjnk13w200hjxshmxf2kvyxxnra4nc2qzxrg3zq";
  };

  patchPhase = "sed -e 's@/usr/bin/python@${python}/bin/python@' -i configure";

  buildInputs = [ pkgconfig glib zlib libpng gnumake3 ];

  configureFlags = "-v";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    license = stdenv.lib.licenses.lgpl3;
    description = "An opensource database of photographic lenses and their characteristics";
    homepage = http://lensfun.sourceforge.net/;
  };
}
