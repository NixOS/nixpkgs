{ cabal, aeson, attoparsec, doctest, filepath, genericDeriving
, lens, semigroups, simpleReflect, text, unorderedContainers
, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "lens-aeson";
  version = "0.1.2";
  sha256 = "1h0w8p227r8gzvgqjl210i0z7xxv3435vwyi3j7vkm7a05cdk03l";
  buildDepends = [
    aeson attoparsec lens text unorderedContainers utf8String vector
  ];
  testDepends = [
    doctest filepath genericDeriving semigroups simpleReflect
  ];
  meta = {
    homepage = "http://github.com/lens/lens-aeson/";
    description = "Law-abiding lenses for aeson";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
