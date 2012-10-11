{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, filepath, MonadCatchIOTransformers, mtl, random, text, time
, unorderedContainers, vector, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.8.2";
  sha256 = "0zamggvfq9054vxznbnfq1fihk110ih8q0dza1rmsjb1h2s88rkj";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml directoryTree filepath
    MonadCatchIOTransformers mtl random text time unorderedContainers
    vector xmlhtml
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "An (x)html templating system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
