{stdenv, fetchurl, x11}:

stdenv.mkDerivation {
  name = "SDL-1.2.7";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/SDL-1.2.7.tar.gz;
    md5 = "d29b34b6ba3ed213893fc9d8d35e357a";
  };
  buildInputs = [x11];
  patches = [./gcc-3.4.patch];
}
