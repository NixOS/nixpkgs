{ cabal, attoparsec, blazeBuilder, blazeBuilderConduit, conduit
, text
}:

cabal.mkDerivation (self: {
  pname = "tagstream-conduit";
  version = "0.5.2";
  sha256 = "12hg9khc670499c3ymc0s4xd2sg71grlk21ykqmby972dva77vxr";
  buildDepends = [
    attoparsec blazeBuilder blazeBuilderConduit conduit text
  ];
  meta = {
    homepage = "http://github.com/yihuang/tagstream-conduit";
    description = "streamlined html tag parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
