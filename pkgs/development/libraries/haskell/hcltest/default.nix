{ cabal, dlist, doctest, either, filepath, free, lens, mmorph
, monadControl, mtl, optparseApplicative, randomShuffle, split, stm
, tagged, tasty, temporary, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "hcltest";
  version = "0.3.1";
  sha256 = "0qnf6ib01njcbjfbwxff8y4sqmrj6nyy9y9hb0l0kw21cxsgl7c9";
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
