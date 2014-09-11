{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "managed";
  version = "1.0.0";
  sha256 = "06nb71pd68m5l6a48sz5kkrdif74phbg3y6bn9ydd00y515b9gn5";
  buildDepends = [ transformers ];
  meta = {
    description = "A monad for managed values";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
