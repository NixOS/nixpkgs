{ cabal, aeson, shakespeareJs, text, unorderedContainers, vector
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-json";
  version = "0.2.2.1";
  sha256 = "16l5ygj9xsg2lzw3mkn1kmq543n9w5z1g6lyl8nw5bblp66lfxq3";
  buildDepends = [
    aeson shakespeareJs text unorderedContainers vector yesodCore
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
