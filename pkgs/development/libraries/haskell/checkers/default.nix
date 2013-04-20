{ cabal, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "checkers";
  version = "0.3.1";
  sha256 = "0lhy8bk8kkj540kjbc76j4x4xsprqwlmxdrss4r0j1bxgmfwha6p";
  buildDepends = [ QuickCheck random ];
  meta = {
    description = "Check properties on standard classes and data structures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
