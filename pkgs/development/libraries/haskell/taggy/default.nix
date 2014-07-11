{ cabal, attoparsec, blazeHtml, blazeMarkup, hspec, hspecAttoparsec
, text, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "taggy";
  version = "0.1";
  sha256 = "0qqz5h706k96i7gl8vvn4c044cd5wj1zjlr6cnlxxpii0pyiiwh1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec blazeHtml blazeMarkup text unorderedContainers vector
  ];
  testDepends = [
    attoparsec blazeHtml blazeMarkup hspec hspecAttoparsec text
    unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/alpmestan/taggy";
    description = "Efficient and simple HTML/XML parsing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
