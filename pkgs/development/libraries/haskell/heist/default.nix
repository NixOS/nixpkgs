{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, dlist, errors, filepath, hashable, MonadCatchIOTransformers, mtl
, random, text, time, transformers, unorderedContainers, vector
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.13.0.6";
  sha256 = "1h34bmcb9bqkagcx3iqnp4l8z8qhngf00mki4hpk905znja6hib9";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeHtml directoryTree dlist errors
    filepath hashable MonadCatchIOTransformers mtl random text time
    transformers unorderedContainers vector xmlhtml
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "An Haskell template system supporting both HTML5 and XML";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
