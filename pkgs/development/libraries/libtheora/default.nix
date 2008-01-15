{stdenv, fetchurl, libogg, libvorbis}:

stdenv.mkDerivation {
  name = "libtheora-1.0beta2";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/theora/libtheora-1.0beta2.tar.gz;
    sha256 = "0iwwprpi4s9y37c5yvlb572wd5gb2s635pxrkz5589266g1j1dcg";
  };
  propagatedBuildInputs = [libogg libvorbis];
}
