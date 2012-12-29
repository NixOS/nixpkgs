{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.5";
  sha256 = "0dnxqqxfyxj0mpy524nvgwagsp6ynadmh2yr4k5159rzbg2xgz90";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
