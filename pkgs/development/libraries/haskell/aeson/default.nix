{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, mtl
, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.6.0.2";
  sha256 = "04vyjpp3zi2g65rrkq4x4bddw0nfclniq5hhfq7l3jhybd8jxy51";
  buildDepends = [
    attoparsec blazeBuilder deepseq dlist hashable mtl syb text time
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
