{cabal, polyparse}:

cabal.mkDerivation (self : {
  pname = "HaXml";
  version = "1.22.2";
  sha256 = "8d4706430a1bdd1cb09e6e346f108a24c8d420d0240b2706633b9e949e67b355";
  propagatedBuildInputs = [polyparse];
  /* Avoid the following error:

      src/Text/XML/HaXml/Schema/Schema.hs:50:21:
	  parse error on input `{- | t -> s -}'
   */
  noHaddock = true;
  meta = {
    description = "Haskell utilities for parsing, filtering, transforming and generating XML documents.";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})

