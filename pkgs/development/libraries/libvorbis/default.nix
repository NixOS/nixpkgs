{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "libvorbis-1.1.0";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libvorbis-1.1.0.tar.gz;
    md5 = "bb764aeabde613d1a424a29b1f15e7e6" ;
  };

   buildInputs = [libogg];
}
