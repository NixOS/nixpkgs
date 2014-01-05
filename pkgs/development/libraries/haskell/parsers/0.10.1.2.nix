{ cabal, charset, doctest, filepath, parsec, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.10.1.2";
  sha256 = "1malfr2ls7f6di2rj2jcyxyqvjz0vb3p3v06j0r9if1bkjfzfp2j";
  buildDepends = [
    charset parsec text transformers unorderedContainers
  ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/parsers/";
    description = "Parsing combinators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
