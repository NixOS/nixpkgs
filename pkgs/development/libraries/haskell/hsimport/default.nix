{ cabal, attoparsec, cmdargs, filepath, haskellSrcExts, lens, mtl
, split, tasty, tastyGolden, text
}:

cabal.mkDerivation (self: {
  pname = "hsimport";
  version = "0.2.10";
  sha256 = "0xvsjgckh2jab9q7l8pvnnn5x977mb6hkhqb175m10brr13yzk4z";
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
