{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikes-1.22";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/jikes/jikes-1.22.tar.bz2;
    md5 = "cda958c7fef6b43b803e1d1ef9afcb85";
  };
}
