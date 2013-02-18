{ cabal, blazeBuilder, blazeHtml, blazeMarkup, parsec, text
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "xmlhtml";
  version = "0.2.0.3";
  sha256 = "03bwsm3dazc01cwndlm92nr35a4fllsxx17rp72d2vnf1571a1vb";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup parsec text unorderedContainers
  ];
  jailbreak = true;
  meta = {
    description = "XML parser and renderer with HTML 5 quirks mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
