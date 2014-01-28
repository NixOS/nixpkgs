{ cabal, aeson, cpphs, Diff, filepath, haskellSrcExts, HUnit
, liftedBase, monadControl, mtl, QuickCheck, random, regexCompat
, temporary, text, unorderedContainers, xmlgen
}:

cabal.mkDerivation (self: {
  pname = "HTF";
  version = "0.11.1.0";
  sha256 = "0prijzy852fkr8z58rhba6jvrb27b6lyz2jdgqb7r1jrnkhqmhpq";
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
