{ cabal, attoparsec, charset, doctest, filepath, parsec, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.11.0.1";
  sha256 = "0jg91zzsq12vxxsxrd1kx8h2c06asccymjbpx0zl7nvj5dhjfkpq";
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
