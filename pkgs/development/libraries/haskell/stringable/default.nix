{ cabal, systemFilepath, text }:

cabal.mkDerivation (self: {
  pname = "stringable";
  version = "0.1.2";
  sha256 = "17lhry3x90s88lplbv2kvzyak8wrc9r80czng5s3dirmyp9rn5gs";
  buildDepends = [ systemFilepath text ];
  meta = {
    description = "A Stringable type class, in the spirit of Foldable and Traversable";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
