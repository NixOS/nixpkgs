{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libdvbpsi-${version}";
  version = "0.2.2";

  src = fetchurl {
    url = "http://get.videolan.org/libdvbpsi/${version}/${name}.tar.bz2";
    sha256 = "1lry2swxqm8mhq0a4rjnc819ngsf2pxnfjajb57lml7yr12j79ls";
  };

  meta = {
    description = "A simple library designed for decoding and generation of MPEG TS and DVB PSI tables according to standards ISO/IEC 13818 and ITU-T H.222.0";
    homepage = http://www.videolan.org/developers/libdvbpsi.html ;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.lgpl21;
  };

}
