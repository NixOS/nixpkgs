{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "deepseq-th";
  version = "0.1.0.4";
  sha256 = "12wk8higrp12b22zzz1b4ar1q5h7flk22bp2rvswsqri2zkbi965";
  buildDepends = [ deepseq ];
  meta = {
    description = "Template Haskell based deriver for optimised NFData instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
