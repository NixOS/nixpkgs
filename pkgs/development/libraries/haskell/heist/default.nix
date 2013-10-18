{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, dlist, errors, filepath, hashable, MonadCatchIOTransformers, mtl
, random, text, time, transformers, unorderedContainers, vector
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.13.0.2";
  sha256 = "0rbzizgrvwj505dk7qyc9ky5vwyaxyj91xz1dsv0mv7cjl9pp17n";
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
