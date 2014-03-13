{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, lens
, QuickCheck, random, systemPosixRedirect, text, time, transformers
, vector, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.1.1";
  sha256 = "00c15zy7190mghpvrpwl0hp8w1mp386vvff8w2zdpgl792cvdby8";
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
