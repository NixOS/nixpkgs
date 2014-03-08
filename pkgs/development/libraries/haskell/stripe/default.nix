{ cabal, aeson, httpConduit, httpTypes, mtl, text, time
, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "stripe";
  version = "0.7.0";
  sha256 = "02kyxipifdaf08bk85cbgksvm3jn7i648h9afb3jfxqam5j4a7a0";
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
