{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.6.0.2";
  sha256 = "0dbn358gxg13lxlpqyczcn5g5kvzrz7lv17qsmr53hvmxz8mricr";
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
