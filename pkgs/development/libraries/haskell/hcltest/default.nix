{ cabal, dlist, doctest, either, filepath, free, lens, mmorph
, monadControl, mtl, optparseApplicative, randomShuffle, split, stm
, tagged, tasty, temporary, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "hcltest";
  version = "0.3.2";
  sha256 = "0q5b0v2gh0b3a15hg25bqj7scbckrkka2ckk49g2mrdz2gpr28bq";
  buildDepends = [
    dlist either filepath free lens mmorph monadControl mtl
    optparseApplicative randomShuffle split stm tagged tasty temporary
    text transformers transformersBase
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/bennofs/hcltest/";
    description = "A testing library for command line applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
