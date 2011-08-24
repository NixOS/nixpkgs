{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  name = "libvorbis-1.3.2";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/${name}.tar.bz2";
    sha256 = "159khaa9j0pd4fm554m1igzmrhsa3qbh4n8avihfinwym05vc14z";
  };

  propagatedBuildInputs = [ libogg ];

  meta = {
    homepage = http://xiph.org/vorbis/;
  };
}
