{ cabal, blazeBuilder, blazeHtml, blazeMarkup, parsec, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "xmlhtml";
  version = "0.2.3";
  sha256 = "0yg56rj8ylnaawqx3h54g0dlayql87h40anbp7lccnl70pzbk6c7";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup parsec text unorderedContainers
  ];
  meta = {
    description = "XML parser and renderer with HTML 5 quirks mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
