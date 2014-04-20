{ cabal, attoparsec, cmdargs, filepath, haskellSrcExts, lens, mtl
, split, tasty, tastyGolden, text
}:

cabal.mkDerivation (self: {
  pname = "hsimport";
  version = "0.3";
  sha256 = "124dimaa8v4x6vlh51v2r7569d8122l42q19bpzgqih33vw2djcs";
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
