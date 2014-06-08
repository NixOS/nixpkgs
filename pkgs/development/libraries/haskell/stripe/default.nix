{ cabal, aeson, httpConduit, httpTypes, mtl, text, time
, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "stripe";
  version = "0.8.1";
  sha256 = "0vmgj9n7q8ik31z7zzfjfv1qj8f8vrqn9cvk8kjp3k4shj25p7sy";
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
