{ cabal, caseInsensitive, hspec, httpTypes, QuickCheck
, quickcheckInstances
}:

cabal.mkDerivation (self: {
  pname = "http-kit";
  version = "0.4.0";
  sha256 = "0g7gc8faxibj0rhfasa6iaf7ikq4rs0428gca6mhaqp3zf8j7m8h";
  buildDepends = [ caseInsensitive httpTypes ];
  testDepends = [ hspec httpTypes QuickCheck quickcheckInstances ];
  meta = {
    description = "A low-level HTTP library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
