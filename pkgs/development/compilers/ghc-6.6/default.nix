{stdenv, fetchurl, readline, ghc, perl, m4}:

stdenv.mkDerivation {
  name = "ghc-6.6";

  src = map fetchurl [
    { url = http://www.haskell.org/ghc/dist/6.6/ghc-6.6-src.tar.bz2;
      md5 = "2427a8d7d14f86e0878df6b54938acf7";
    }
    { url = http://www.haskell.org/ghc/dist/6.6/ghc-6.6-src-extralibs.tar.bz2;
      md5 = "14b22fce36caffa509046361724bc119";
    }
  ];

  builder = ./builder.sh;

  buildInputs = [ghc readline perl m4];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler v6.6";
  };
}
