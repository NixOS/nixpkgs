{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.5";
  sha256 = "0cppm8iksz4dnh4kafyfy0cqbidw83rdpgc1mksiwh9c9gaxrlq7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Diff filepath HUnit mtl parsec split time utf8String xml
  ];
  meta = {
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
