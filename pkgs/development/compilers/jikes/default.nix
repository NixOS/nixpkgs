{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikes-1.22";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/jikes-1.22.tar.bz2;
    md5 = "cda958c7fef6b43b803e1d1ef9afcb85";
  };
}
