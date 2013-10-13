{ cabal, newtype }:

cabal.mkDerivation (self: {
  pname = "constraints";
  version = "0.3.4.1";
  sha256 = "13jxh2cgcfyiqhx7j5063k8k60wz9h4hd5lf2mw2skbcryg6csmb";
  buildDepends = [ newtype ];
  meta = {
    homepage = "http://github.com/ekmett/constraints/";
    description = "Constraint manipulation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
