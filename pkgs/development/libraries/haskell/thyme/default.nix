{ cabal, attoparsec, deepseq, lens, QuickCheck
, random, text, time, transformers, vector
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "thyme";
  version = "0.3.0.0";
  sha256 = "0nv8kp5ax0088z0d9y93xkv59v1i8wrrdprsj7bknk3yn0gd2gb3";
  buildDepends = [
    attoparsec deepseq lens QuickCheck random text time transformers
    vector vectorSpace
  ];
  # have some strange test depends
  doCheck = false;
  meta = {
    homepage = "https://github.com/liyang/thyme";
    description = "A faster time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
