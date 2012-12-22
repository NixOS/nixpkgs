{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.4.3";
  sha256 = "1zsydxgq3lcgzrf9iwas3gkjy0vxn4z2cj6h3m63h0qqa26sfcwz";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
