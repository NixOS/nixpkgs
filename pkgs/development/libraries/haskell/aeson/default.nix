{ cabal, attoparsec, blazeBuilder, blazeTextual, deepseq, dlist
, hashable, mtl, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.4.0.1";
  sha256 = "15aq3r36vda8v1fn3pn0k638w32kzy15kbrf97krvg3xdwrvybky";
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
