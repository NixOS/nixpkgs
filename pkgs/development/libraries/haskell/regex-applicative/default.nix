{ cabal, HUnit, smallcheck, tasty, tastyHunit, tastySmallcheck
, transformers
}:

cabal.mkDerivation (self: {
  pname = "regex-applicative";
  version = "0.3.0.2";
  sha256 = "0bzf8lnb5568glppk8bajh4c3a08baav5r0qhyn3vnfybi02c4d2";
  buildDepends = [ transformers ];
  testDepends = [
    HUnit smallcheck tasty tastyHunit tastySmallcheck transformers
  ];
  meta = {
    homepage = "https://github.com/feuerbach/regex-applicative";
    description = "Regex-based parsing with applicative interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
