{ stdenv, fetchurl, zlib, libpng, libjpeg, lcms, automake110x, autoconf, libtool }:

stdenv.mkDerivation rec {
  name = "libmng-1.0.10";

  src = fetchurl {
    url = "mirror://sourceforge/libmng/${name}.tar.bz2";
    sha256 = "06415s40gz833s1v1q7c04c0m49p4sc87ich0vpdid2ldj0pf53v";
  };

  preConfigure = "unmaintained/autogen.sh";

  nativeBuildInputs = [ automake110x autoconf libtool ];

  propagatedBuildInputs = [ zlib libpng libjpeg lcms ];

  meta = {
    description = "Reference library for reading, displaying, writing and examining Multiple-Image Network Graphics";
    homepage = http://www.libmng.com;
    license = "zlib/libpng";
    maintainers = with stdenv.lib.maintainers; [ marcweber urkud ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
