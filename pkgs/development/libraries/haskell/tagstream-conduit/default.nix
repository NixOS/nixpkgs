{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "tagstream-conduit";
  version = "0.5.4";
  sha256 = "1djf66kn3m4sdwmis82f9w2nkmjyrq12zda7ic9pcsvra579868i";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    caseInsensitive conduit text transformers
  ];
  meta = {
    homepage = "http://github.com/yihuang/tagstream-conduit";
    description = "streamlined html tag parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
