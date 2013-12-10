{ cabal, hspec, HUnit, QuickCheck, text, time }:

cabal.mkDerivation (self: {
  pname = "path-pieces";
  version = "0.1.3.1";
  sha256 = "140pkci5k6aa9ncxa29fn2p0g6lb79zci0k02nblv59qmj5hj8ic";
  buildDepends = [ text time ];
  testDepends = [ hspec HUnit QuickCheck text ];
  meta = {
    description = "Components of paths";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
