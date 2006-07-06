{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "libvorbis-1.1.2";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/vorbis/libvorbis-1.1.2.tar.gz;
    md5 = "37847626b8e1b53ae79a34714c7b3211";
  };
  buildInputs = [libogg];
}
