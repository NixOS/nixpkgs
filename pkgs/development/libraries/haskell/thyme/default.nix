{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, lens
, QuickCheck, random, systemPosixRedirect, text, time, transformers
, vector, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.1.0";
  sha256 = "0dhnsqn6miiqnbpqln2vmkq7cbm8bz5jz1dwc1bif6dwl16fvhm6";
  buildDepends = [
    aeson attoparsec deepseq lens QuickCheck random text time
    transformers vector vectorSpace
  ];
  testDepends = [
    attoparsec Cabal filepath lens QuickCheck random
    systemPosixRedirect text time vectorSpace
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/liyang/thyme";
    description = "A faster time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
