{ cabal, blazeBuilder, blazeHtml, blazeMarkup, parsec, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "xmlhtml";
  version = "0.2.3.1";
  sha256 = "138nryn68f58cvg971qw7vw0kprsw5g39j3fmf0bz83sg4g98nmd";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup parsec text unorderedContainers
  ];
  meta = {
    description = "XML parser and renderer with HTML 5 quirks mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
