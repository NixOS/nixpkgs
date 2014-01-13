{ cabal, charset, doctest, filepath, parsec, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.10.2";
  sha256 = "092wck874sdyyh4aql5kzsm8k9a7dscgndvzarhh98by5k3n45bk";
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
