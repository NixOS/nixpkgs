{ stdenv, fetchurl, libogg, xz }:

stdenv.mkDerivation rec {
  name = "libvorbis-1.3.3";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.xz";
    sha256 = "1gby6hapz9njx4l9g0pndyk4q83z5fgrgc30mfwfgx7bllspsk43";
  };

  buildNativeInputs = [ xz ];
  propagatedBuildInputs = [ libogg ];

  meta = {
    homepage = http://xiph.org/vorbis/;
  };
}
