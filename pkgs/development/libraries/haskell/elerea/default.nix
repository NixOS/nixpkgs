{ cabal }:

cabal.mkDerivation (self: {
  pname = "elerea";
  version = "2.7.0.2";
  sha256 = "1n45q1hx548c6yqbj3321lky3xxsffpqvmcq0m9hw36d3cvwbvg0";
  meta = {
    description = "A minimalistic FRP library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
