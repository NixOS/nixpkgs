{stdenv, fetchurl, libogg, libvorbis}:

stdenv.mkDerivation {
  name = "libtheora-1.0alpha4";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/theora/libtheora-1.0alpha4.tar.bz2;
    md5 = "a71ac42ec0f848da327930841a80ff2b";
  };
  propagatedBuildInputs = [libogg libvorbis];
}
