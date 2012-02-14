{ cabal, Cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "parallel";
  version = "2.2.0.1";
  sha256 = "255310023138ecf618c8b450203fa2fc65feb68cd08ee4d369ceae72054168fd";
  buildDepends = [ Cabal deepseq ];
  meta = {
    description = "Parallel programming library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
