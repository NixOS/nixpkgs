{ cabal, async, basicPrelude, deepseq, hashable, hspec, liftedBase
, monadControl, QuickCheck, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.5.9";
  sha256 = "1qqmip3ynqdxlwynm60wsn82dcyymcfql79k039iablanj4mic61";
  buildDepends = [
    async basicPrelude deepseq hashable liftedBase monadControl
    systemFilepath text transformers unorderedContainers vector
  ];
  testDepends = [ hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
