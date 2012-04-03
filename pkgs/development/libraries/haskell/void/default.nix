{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.5.5";
  sha256 = "011ji37d5f6xrvd6sq0zkzggaq11r7nyb2z5v3ix3kn14r5psfz3";
  buildDepends = [ semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
