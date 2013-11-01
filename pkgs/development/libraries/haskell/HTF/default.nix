{ cabal, aeson, cpphs, Diff, filepath, haskellSrcExts, HUnit
, liftedBase, monadControl, mtl, QuickCheck, random, regexCompat
, temporary, text, unorderedContainers, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.11.0.1";
  sha256 = "0c4z76rsmdck60p7p2ypxx0d0r7k2vcb9viqp2yalyxzaaj7a9f5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson cpphs Diff haskellSrcExts HUnit liftedBase monadControl mtl
    QuickCheck random regexCompat text xmlgen
  ];
  testDepends = [
    aeson filepath mtl random regexCompat temporary text
    unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/skogsbaer/HTF/";
    description = "The Haskell Test Framework";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
  };
})
