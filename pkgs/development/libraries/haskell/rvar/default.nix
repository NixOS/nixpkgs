{cabal, MonadPrompt, mtl, randomSource, transformers} :

cabal.mkDerivation (self : {
  pname = "rvar";
  version = "0.2";
  sha256 = "1in2qn1clv9b7ijyllhjflh9zdkna31hpyclhlkfnsc6899z3y1f";
  propagatedBuildInputs = [
    MonadPrompt mtl randomSource transformers
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Random Variables";
    license = self.stdenv.lib.licenses.publicDomain;
  };
})
