{ cabal, attoparsec, cmdargs, filepath, haskellSrcExts, lens, mtl
, split, tasty, tastyGolden, text
}:

cabal.mkDerivation (self: {
  pname = "hsimport";
  version = "0.2.9";
  sha256 = "1xfz1as980jg3crlwlajaj8yfj4pl4phg9l6fjap037vr0107hav";
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
