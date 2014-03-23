{ cabal, primitive, text, transformers, vector }:

cabal.mkDerivation (self: {
  pname = "foldl";
  version = "1.0.3";
  sha256 = "0jl50bh7k8wp0nz0s0sb2zwh92yrgsm2l6szib41g7zq34mwamn9";
  buildDepends = [ primitive text transformers vector ];
  meta = {
    description = "Composable, streaming, and efficient left folds";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
