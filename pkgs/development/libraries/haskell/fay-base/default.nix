{ cabal, fay }:

cabal.mkDerivation (self: {
  pname = "fay-base";
  version = "0.19.1.1";
  sha256 = "1qn48aj7j33gvb6vmz986cqi41zvh62sbmmvwgyhpmrhsfkm5wkz";
  buildDepends = [ fay ];
  meta = {
    homepage = "https://github.com/faylang/fay-base";
    description = "The base package for Fay";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
