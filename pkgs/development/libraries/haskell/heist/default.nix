{ cabal, aeson, attoparsec, blazeBuilder, blazeHtml, directoryTree
, dlist, errors, filepath, hashable, MonadCatchIOTransformers, mtl
, random, text, time, transformers, unorderedContainers, vector
, xmlhtml
}:

cabal.mkDerivation (self: {
  pname = "heist";
  version = "0.13.0.1";
  sha256 = "1hxf131xhvsqbvmrm8wbjpndy41pz1lq65gqlk3lxr57dhi59s4w";
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
