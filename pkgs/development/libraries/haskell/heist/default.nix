{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, dlist, errors, filepath, hashable, MonadCatchIOTransformers, mtl
, random, text, time, unorderedContainers, vector, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.10.0";
  sha256 = "0cabn1yw57qa7psmypqa20k4viis140al5zm31jlpmz599rkbi9z";
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
