{stdenv, fetchurl, libogg, libvorbis}:

stdenv.mkDerivation {
  name = "libtheora-1.0";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/theora/libtheora-1.0.tar.gz;
    sha256 = "0j5hv0pfsiwa2qq5d647py4g7ixnax1v47xc3aj5sa9v2iknib6m";
  };
  propagatedBuildInputs = [libogg libvorbis];
}
