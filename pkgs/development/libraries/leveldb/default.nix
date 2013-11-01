{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "leveldb-1.9.0";

  src = fetchurl {
    url = "https://leveldb.googlecode.com/files/${name}.tar.gz";
    sha256 = "b2699b04e5aba8e98382c4955b94725d1f76bd0b5decd60c5628205b717a1d4f";
  };

  buildPhase = "make all db_bench";

  installPhase = "
    mkdir -p $out/lib/
    cp libleveldb* $out/lib/
    mkdir -p $out/include/
    cp -r include $out/
    mkdir -p $out/bin/
    cp db_bench $out/lib/
  ";

  meta = {
    homepage = "https://code.google.com/p/leveldb/";
    description = "Fast and lightweight key/value database library by Google";
    license = "BSD";
  };
}
