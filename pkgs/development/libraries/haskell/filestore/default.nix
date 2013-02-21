{ cabal, Diff, filepath, HUnit, mtl, parsec, split, time
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "filestore";
  version = "0.6";
  sha256 = "1bmsqxrkiqw791h0xwasry3jm56rjsyvl9l5r78209bhiv5v6xk0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Diff filepath HUnit mtl parsec split time utf8String xml
  ];
  jailbreak = true;
  meta = {
    description = "Interface for versioning file stores";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
