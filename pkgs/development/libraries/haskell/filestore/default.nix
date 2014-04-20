{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.6.0.1";
  sha256 = "1la30bimcjngcv5dyx1a9x8lr8c4zs0dp4kzh8y5mjf8snky1avf";
  buildDepends = [ Diff filepath parsec split time utf8String xml ];
  testDepends = [ Diff filepath HUnit mtl time ];
  jailbreak = true;
  meta = {
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
