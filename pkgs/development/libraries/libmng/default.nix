{ stdenv, fetchurl, zlib, libpng, libjpeg, lcms, automake, autoconf, libtool }:

stdenv.mkDerivation {
  name = "libmng-1.0.10";

  src = fetchurl {
    url = mirror://sourceforge/libmng/libmng-devel/1.0.10/libmng-1.0.10.tar.bz2;
    sha256 = "06415s40gz833s1v1q7c04c0m49p4sc87ich0vpdid2ldj0pf53v";
  };

  preConfigure = "unmaintained/autogen.sh";

  buildInputs = [ zlib libpng libjpeg lcms automake autoconf libtool ];

  meta = { 
    description = "Reference library for reading, displaying, writing and examining Multiple-Image Network Graphics";
    homepage = http://sourceforge.net/projects/libmng;
    license = "zlib/libpng";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
