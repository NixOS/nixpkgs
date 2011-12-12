{ cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, dlist
, hashable, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.4.0.0";
  sha256 = "1j0m7hh82ab7lg757wq75k28llfd1igawmg4g2qdia5gimm652pa";
  buildDepends = [
    attoparsec blazeBuilder blazeTextual deepseq dlist hashable mtl syb
    text time unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
