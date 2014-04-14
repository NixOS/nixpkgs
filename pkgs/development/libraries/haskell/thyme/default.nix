{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, mtl
, profunctors, QuickCheck, random, systemPosixRedirect, text, time
, vector, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.3.0";
  sha256 = "0mpwwpc82xcdyawz87rcmvga1miw7cx538nnh379m2ibn0g71zaa";
  buildDepends = [
    aeson attoparsec deepseq mtl profunctors QuickCheck random text
    time vector vectorSpace
  ];
  testDepends = [
    attoparsec Cabal filepath mtl profunctors QuickCheck random
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
