{ cabal, aeson, blazeBuilder, shakespeareJs, text
, unorderedContainers, vector, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.2.2.2";
  sha256 = "0mhajy0hal9icwys63vcmlipl3gwm8bvv7xywwjydd86drqhz9ni";
  buildDepends = [
    aeson blazeBuilder shakespeareJs text unorderedContainers vector
    yesodCore
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
