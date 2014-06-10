{ cabal, attoparsec, charset, doctest, filepath, parsec, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.11.0.2";
  sha256 = "0b2qb6lhn647926s2g7qrzhnvnym5dr7fny784bv19mfvimwi81c";
  buildDepends = [
    attoparsec charset parsec text transformers unorderedContainers
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/parsers/";
    description = "Parsing combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
