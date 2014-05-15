{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, mtl
, profunctors, QuickCheck, random, systemPosixRedirect, text, time
, vector, vectorSpace, vectorThUnbox
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.5.0";
  sha256 = "0jc687hdxz97qjslminwqgj40pnnyhpfv73j6d8pmg064svdrg0q";
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
