{ cabal, aeson, httpConduit, httpTypes, mtl, text, time
, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "stripe";
  version = "0.8.0";
  sha256 = "0bz932v7kcz2xsnmpx34ifqnf6kbgy7a7qd0dqnjqypc8g6kfl37";
  buildDepends = [
    aeson httpConduit httpTypes mtl text time unorderedContainers
    utf8String
  ];
  meta = {
    homepage = "https://github.com/michaelschade/hs-stripe";
    description = "A Haskell implementation of the Stripe API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
