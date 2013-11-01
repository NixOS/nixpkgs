{ cabal, deepseq, syb }:

cabal.mkDerivation (self: {
  pname = "symbol";
  version = "0.2.0";
  sha256 = "13vr6j3wkxbdbd27xklnidfkpkjwl0kldf69z470bm5indvaaxfd";
  buildDepends = [ deepseq syb ];
  jailbreak = true;
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "A 'Symbol' type for fast symbol comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
