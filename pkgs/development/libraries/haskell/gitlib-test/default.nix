{ cabal, conduit, conduitCombinators, exceptions, gitlib, hspec
, hspecExpectations, HUnit, monadControl, tagged, text, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "gitlib-test";
  version = "3.1.0";
  sha256 = "0hnwx5r9fdkxvx0zmqffpym921dvf1x2lky8w11y3rfhk9i1g7l4";
  buildDepends = [
    conduit conduitCombinators exceptions gitlib hspec
    hspecExpectations HUnit monadControl tagged text time transformers
  ];
  meta = {
    description = "Test library for confirming gitlib backend compliance";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
