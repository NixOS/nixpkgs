{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "audiofile-0.2.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/audiofile-0.2.5.tar.gz;
    md5 = "fd07c62a17ceafa317929e55e51e26c5";
  };
}
