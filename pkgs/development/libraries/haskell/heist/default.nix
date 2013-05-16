{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, dlist, errors, filepath, hashable, MonadCatchIOTransformers, mtl
, random, text, time, transformers, unorderedContainers, vector
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.12.0";
  sha256 = "0fdqvippsxljylchfcr32lw367i17cpv4yavjvmhfd923vgmmfj9";
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
