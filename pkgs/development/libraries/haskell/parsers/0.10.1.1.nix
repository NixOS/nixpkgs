{ cabal, charset, doctest, filepath, parsec, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "parsers";
  version = "0.10.1.1";
  sha256 = "1w3dj3r2l0w54rafngrp7r1spqznbj5yzilkprqxvbvvj3jxgn5a";
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
