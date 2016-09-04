{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikes-1.22";
  src = fetchurl {
    url = mirror://sourceforge/jikes/jikes-1.22.tar.bz2;
    md5 = "cda958c7fef6b43b803e1d1ef9afcb85";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
