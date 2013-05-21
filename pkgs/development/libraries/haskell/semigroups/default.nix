{ cabal, nats }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.9.2";
  sha256 = "06r6zdfbks48yb7ib0bc168xxk4qciv4dbazq76dpmnlhwxcf1li";
  buildDepends = [ nats ];
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
