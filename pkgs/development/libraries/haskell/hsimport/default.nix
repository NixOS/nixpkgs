{ cabal, attoparsec, cmdargs, filepath, haskellSrcExts, lens, mtl
, split, tasty, tastyGolden, text
}:

cabal.mkDerivation (self: {
  pname = "hsimport";
  version = "0.2.6.6";
  sha256 = "07zlzshg7q1gh96wqifnjanl9nfz8y4rmszmrjm7plkkpxymma4z";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec cmdargs haskellSrcExts lens mtl split text
  ];
  testDepends = [ filepath tasty tastyGolden ];
  meta = {
    description = "A command line program for extending the import list of a Haskell source file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
  doCheck = false;
})
