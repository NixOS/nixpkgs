{ cabal, caseInsensitive, hspec, httpTypes, QuickCheck
, quickcheckInstances
}:

cabal.mkDerivation (self: {
  pname = "http-kit";
  version = "0.2.1";
  sha256 = "1x3wqjbgs605wrl2dgvszdkvpkfrin4j9azkaa57hza6bgwpidra";
  buildDepends = [ caseInsensitive httpTypes ];
  testDepends = [ hspec httpTypes QuickCheck quickcheckInstances ];
  meta = {
    description = "A low-level HTTP library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
