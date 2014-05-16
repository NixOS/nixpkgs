{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, mtl
, profunctors, QuickCheck, random, systemPosixRedirect, text, time
, vector, vectorSpace, vectorThUnbox
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.5.1";
  sha256 = "0v3aq7zv4fnkjhfc7mm6vx2wb5dh2npf2lsgpvcrdpy5zlfsrx50";
  buildDepends = [
    aeson attoparsec deepseq mtl profunctors QuickCheck random text
    time vector vectorSpace vectorThUnbox
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
