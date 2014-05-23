{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "minioperational";
  version = "0.4.3";
  sha256 = "09z8536q0cc09iack6s8fghgrc5f3syq3sxf2cnai3rcfaqix86p";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/fumieval/minioperational";
    description = "fast and simple operational monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
