{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.4.1";
  sha256 = "00byv248662n6pr8gn5b777l0fjg6f0wcxfkbhw0qyhd1ciq8d38";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
