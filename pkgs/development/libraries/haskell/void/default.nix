{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.5.12";
  sha256 = "03fqcap94saj7mx3y4pvvfj4z8dy6rsk2kvhgbnk2wvz5xm7xvci";
  buildDepends = [ semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
