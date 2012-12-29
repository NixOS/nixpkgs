{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, dlist, errors, filepath, hashable, MonadCatchIOTransformers, mtl
, random, text, time, unorderedContainers, vector, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.10.2";
  sha256 = "13v9x5dph52xddkb2dy4gfrapvihf1881fin996ag0snbma3wh68";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml directoryTree dlist errors
    filepath hashable MonadCatchIOTransformers mtl random text time
    unorderedContainers vector xmlhtml
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "An Haskell template system supporting both HTML5 and XML";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
