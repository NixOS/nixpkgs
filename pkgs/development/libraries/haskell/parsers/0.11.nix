{ cabal, attoparsec, charset, doctest, filepath, parsec, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.11";
  sha256 = "0k3xm9ww4q2wkjik4n4ww6ys79kl7xyzbhcb7xi81jz9py0xciqd";
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
