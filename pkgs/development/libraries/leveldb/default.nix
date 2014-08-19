{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "leveldb-1.15.0";

  src = fetchurl {
    url = "https://leveldb.googlecode.com/files/${name}.tar.gz";
    sha256 = "10363j8qmlyh971ipb7fmgk9b97bl5267c0xyccrgvpj3rbyri6p";
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
