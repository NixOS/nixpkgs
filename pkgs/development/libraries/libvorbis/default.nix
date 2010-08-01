{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  name = "libvorbis-1.3.1";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.bz2";
    sha256 = "1q6gah9g6w5gxjq95x1x81a4w76p3caivq1bw4hxs0z9rx05qj22";
  };

  propagatedBuildInputs = [ libogg ];

  meta = {
    homepage = http://xiph.org/vorbis/;
  };
}
