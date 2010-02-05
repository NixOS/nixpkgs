{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "libvorbis-1.2.3";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/libvorbis-1.2.3.tar.bz2;
    sha256 = "0aj9jfxsp89vs78321sqvj8my4bxcb7pjr959nhi9wj0r032gyfv";
  };

  propagatedBuildInputs = [ libogg ];
}
