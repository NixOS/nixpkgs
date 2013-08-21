{ cabal, newtype }:

cabal.mkDerivation (self: {
  pname = "constraints";
  version = "0.3.3";
  sha256 = "0mglqd6l6bc333i7gymbm8q037hj5fny6jzyg1zmw5kg6r3xcwdi";
  buildDepends = [ newtype ];
  meta = {
    homepage = "http://github.com/ekmett/constraints/";
    description = "Constraint manipulation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
