{ cabal, caseInsensitive, hspec, httpTypes, QuickCheck
, quickcheckInstances
}:

cabal.mkDerivation (self: {
  pname = "http-kit";
  version = "0.5.0";
  sha256 = "0djg2gg12w9sd598hx959cgr5027ghza3m6aaym9ipb43w6mds5p";
  buildDepends = [ caseInsensitive httpTypes ];
  testDepends = [ hspec httpTypes QuickCheck quickcheckInstances ];
  meta = {
    description = "A low-level HTTP library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
