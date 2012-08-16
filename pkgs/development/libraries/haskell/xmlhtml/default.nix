{ cabal, blazeBuilder, blazeHtml, blazeMarkup, parsec, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "xmlhtml";
  version = "0.2.0.2";
  sha256 = "0dqlqx3cnrqap3ficdkmwm8661j8i7qknb8xhjqvfmnb9pwqdks2";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup parsec text unorderedContainers
  ];
  meta = {
    description = "XML parser and renderer with HTML 5 quirks mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
