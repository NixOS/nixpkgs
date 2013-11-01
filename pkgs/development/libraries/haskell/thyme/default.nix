{ cabal, attoparsec, Cabal, deepseq, filepath, lens, QuickCheck
, random, systemPosixRedirect, text, time, transformers, vector
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.0.1";
  sha256 = "086i8cadq2s894157s1bh3zhd9zb9apr7w39gnydywzgkx47478h";
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
