{ cabal, blazeBuilder, filepath, HUnit, hxt, mtl, QuickCheck, text
}:

cabal.mkDerivation (self: {
  pname = "xmlgen";
  version = "0.6.2.0";
  sha256 = "0b6fyg6mlm068f2jjmil52az4hk144pryf1c0wr1gx6ddx9yzjy4";
  buildDepends = [ blazeBuilder mtl text ];
  testDepends = [ filepath HUnit hxt QuickCheck text ];
  meta = {
    description = "Fast XML generation library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
