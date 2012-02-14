{ cabal, Cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "deepseq-th";
  version = "0.1.0.2";
  sha256 = "0f2hrp2rjb3iailnxh47wl1imgq6jqr9qj31vi7k8lgp5pwa90mc";
  buildDepends = [ Cabal deepseq ];
  meta = {
    description = "Template Haskell based deriver for optimised NFData instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
