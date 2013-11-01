{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, hspec, HUnit
, QuickCheck, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "tagstream-conduit";
  version = "0.5.4.1";
  sha256 = "1gahdil5jasm6v7gp519ahr2yc7ppysdnmkl21cd4zzn6y1r0gw9";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    caseInsensitive conduit text transformers
  ];
  testDepends = [ conduit hspec HUnit QuickCheck text ];
  meta = {
    homepage = "http://github.com/yihuang/tagstream-conduit";
    description = "streamlined html tag parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
