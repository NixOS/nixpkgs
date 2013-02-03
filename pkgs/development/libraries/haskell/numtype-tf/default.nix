{ cabal }:

cabal.mkDerivation (self: {
  pname = "numtype-tf";
  version = "0.1";
  sha256 = "1hvnqgjg7yifxdsji9v0wqwbp4syhdc97pa3nrn4p96g7kmvw25v";
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Type-level (low cardinality) integers, implemented using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
