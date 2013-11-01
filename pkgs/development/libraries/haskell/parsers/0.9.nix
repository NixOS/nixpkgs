{ cabal, charset, doctest, filepath, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.9";
  sha256 = "04lbayvdv2hax4s9sqlnia7jpzv1sgls41ylql0xbi2zhz5rvyyi";
  buildDepends = [ charset text transformers unorderedContainers ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/parsers/";
    description = "Parsing combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
