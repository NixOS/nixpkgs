{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, mtl
, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.6.0.0";
  sha256 = "1j8g1q7xr1pgyfyrkbh2zz7fhqshj0q5qg7fczrnsbbzf5k459zw";
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
