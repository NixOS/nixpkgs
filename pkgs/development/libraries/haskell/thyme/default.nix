{ cabal, aeson, attoparsec, Cabal, deepseq, filepath, mtl
, profunctors, QuickCheck, random, systemPosixRedirect, text, time
, vector, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.2.0";
  sha256 = "1jrhqrvmkq8n943l6dkyszg4qz47jbddr80qg7k51a9nrg8fins4";
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
