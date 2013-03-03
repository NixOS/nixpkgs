{ cabal, blazeBuilder, blazeHtml, blazeMarkup, parsec, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "xmlhtml";
  version = "0.2.1";
  sha256 = "1nqkjbhpzr7zxpjvlxy6pync6zyarvjblcxg8igq75dyzk7qhafg";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup parsec text unorderedContainers
  ];
  meta = {
    description = "XML parser and renderer with HTML 5 quirks mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
