{ cabal, attoparsec, Cabal, deepseq, filepath, lens, QuickCheck
, random, systemPosixRedirect, text, time, transformers, vector
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.0.2";
  sha256 = "1drglcl3jv0kp51h72b8dlrr3hpsl480dv1gr4p0vnk6ynls98y6";
  buildDepends = [
    attoparsec deepseq lens QuickCheck random text time transformers
    vector vectorSpace
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
