{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, filepath, MonadCatchIOTransformers, mtl, random, text, time
, transformers, unorderedContainers, vector, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.8.1.1";
  sha256 = "0ad56izskafpc1dx2nq0a8w71ayppwx8dc7kdaw1by972kh3nflh";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml directoryTree filepath
    MonadCatchIOTransformers mtl random text time transformers
    unorderedContainers vector xmlhtml
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "An (x)html templating system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
