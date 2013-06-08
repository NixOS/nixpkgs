{ cabal, binary, criterion, cryptohash, deepseq, HUnit, maccatcher
, mersenneRandomPure64, QuickCheck, random, time
}:

cabal.mkDerivation (self: {
  pname = "uuid";
  version = "1.2.13";
  sha256 = "0y9r71iqvabmvyrglw42g37skgisyknkv3pkfih2qfrfkk75zw0s";
  buildDepends = [ binary cryptohash maccatcher random time ];
  testDepends = [
    criterion deepseq HUnit mersenneRandomPure64 QuickCheck random
  ];
  doCheck = false;
  meta = {
    homepage = "http://projects.haskell.org/uuid/";
    description = "For creating, comparing, parsing and printing Universally Unique Identifiers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
