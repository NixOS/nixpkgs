{stdenv, fetchurl, readline, ghc, perl, m4}:

stdenv.mkDerivation {
  name = "ghc-6.6.1";

  src = map fetchurl [
    { url = http://www.haskell.org/ghc/dist/6.6.1/ghc-6.6.1-src.tar.bz2;
      md5 = "ba9f4aec2fde5ff1e1548ae69b78aeb0";
    }
    { url = http://www.haskell.org/ghc/dist/6.6.1/ghc-6.6.1-src-extralibs.tar.bz2;
      md5 = "43a26b81608b206c056adc3032f7da2a";
    }
  ];

  builder = ./builder.sh;

  buildInputs = [ghc readline perl m4];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler v6.6.1";
  };
}
