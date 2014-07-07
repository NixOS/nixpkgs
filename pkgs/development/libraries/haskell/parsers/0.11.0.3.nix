{ cabal, attoparsec, charset, doctest, filepath, parsec, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.11.0.3";
  sha256 = "0cwjzk76i7isg7h1xl9iv6x87vfw3x2x5jaacx85g8v45lv7g88s";
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
