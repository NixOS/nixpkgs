{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libdvbpsi";
  version = "1.3.3";

  src = fetchurl {
    url = "http://get.videolan.org/libdvbpsi/${version}/${pname}-${version}.tar.bz2";
    sha256 = "04h1l3vrkrdsrvkgzcr51adk10g6hxcxvgjphyyxz718ry5rkd82";
  };

  meta = {
    description = "A simple library designed for decoding and generation of MPEG TS and DVB PSI tables according to standards ISO/IEC 13818 and ITU-T H.222.0";
    homepage = "http://www.videolan.org/developers/libdvbpsi.html";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21;
  };

}
