{ cabal, attoparsec, cmdargs, filepath, haskellSrcExts, lens, mtl
, split, tasty, tastyGolden, text
}:

cabal.mkDerivation (self: {
  pname = "hsimport";
  version = "0.4";
  sha256 = "1pkj6cfdfyrcrm6gr4a43y6s4qhwpli6zgnlx4ycmhs3yh5kay60";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec cmdargs haskellSrcExts lens mtl split text
  ];
  testDepends = [ filepath tasty tastyGolden ];
  doCheck = false;
  meta = {
    description = "A command line program for extending the import list of a Haskell source file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
