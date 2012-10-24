{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.5.0.1";
  sha256 = "1wbiw3skbbcqi9p97xnhg5lnakq3vyan9v4f68wd3g4swk09xp7l";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Diff filepath HUnit mtl parsec split time utf8String xml
  ];
  noHaddock = true;
  meta = {
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
