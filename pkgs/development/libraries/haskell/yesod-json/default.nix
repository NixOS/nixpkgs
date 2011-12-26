{ cabal, aeson, attoparsecEnumerator, blazeBuilder, shakespeareJs
, text, transformers, unorderedContainers, vector, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.2.3";
  sha256 = "0bd75zzxqrarqk8b2v515jv0zbi5x27fmb9cbj3g57l9ig57lqy5";
  buildDepends = [
    aeson attoparsecEnumerator blazeBuilder shakespeareJs text
    transformers unorderedContainers vector yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Generate content for Yesod using the aeson package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
