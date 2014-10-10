{ cabal, byteorder, deepseq, dlist, mtl, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "bytestring";
  version = "0.10.4.0";
  sha256 = "088a0hs3rh7m8f8l72kk9880mfnhd98c0jw530wi303bzxvc3yz3";
  buildDepends = [ deepseq ];
  testDepends = [ byteorder deepseq dlist mtl QuickCheck random ];
  meta = {
    homepage = "https://github.com/haskell/bytestring";
    description = "Fast, compact, strict and lazy byte strings with a list interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
