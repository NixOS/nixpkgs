{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "parallel";
  version = "3.2.0.3";
  sha256 = "1kbdzdz9s8jq0xysqgvxx1zvzqlxgj1sk476mciwcn327kpl0fhn";
  buildDepends = [ deepseq ];
  meta = {
    description = "Parallel programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
