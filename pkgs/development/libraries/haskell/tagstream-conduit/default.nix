{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, dataDefault, hspec
, HUnit, QuickCheck, text, transformers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "tagstream-conduit";
  version = "0.5.5";
  sha256 = "17157chhw610f8az6c25qzq5mmhpb1a8m12kdc2k8khgynpkrj5f";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    caseInsensitive conduit dataDefault text transformers xmlConduit
  ];
  testDepends = [ conduit hspec HUnit QuickCheck text ];
  meta = {
    homepage = "http://github.com/yihuang/tagstream-conduit";
    description = "streamlined html tag parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
